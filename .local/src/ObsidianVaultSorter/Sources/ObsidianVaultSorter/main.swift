import Cocoa
import Foundation

@main
struct ObsidianVaultSorter {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var vaultWatcher: VaultWatcher?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        startVaultWatching()
        
        // Hide dock icon since this is a menubar-only app
        NSApp.setActivationPolicy(.accessory)
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let button = statusItem?.button else { return }
        button.image = NSImage(systemSymbolName: "archivebox", accessibilityDescription: "Vault Sorter")
        button.action = #selector(statusItemClicked)
        button.target = self
        
        updateBadge(count: 0)
    }
    
    @objc private func statusItemClicked() {
        print("Status item clicked!")
        
        // Mark changes as seen
        vaultWatcher?.markAsSeen()
        updateBadge(count: 0)
        
        openITermWithVaultSort()
    }
    
    private func updateBadge(count: Int) {
        guard let button = statusItem?.button else { return }
        
        if count > 0 {
            button.title = " (\(count))"
            button.appearsDisabled = false
        } else {
            button.title = ""
            button.appearsDisabled = true
        }
        
        // Always keep visible
        statusItem?.isVisible = true
    }
    
    private func startVaultWatching() {
        // Get Obsidian vault path from user defaults or environment
        let vaultPath = getVaultPath()
        guard let path = vaultPath else {
            print("No vault path configured. Set OBSIDIAN_VAULT_PATH environment variable.")
            return
        }
        
        vaultWatcher = VaultWatcher(vaultPath: path) { [weak self] count in
            DispatchQueue.main.async {
                self?.updateBadge(count: count)
            }
        }
        vaultWatcher?.start()
    }
    
    private func getVaultPath() -> String? {
        // Try environment variable first
        if let envPath = ProcessInfo.processInfo.environment["OBSIDIAN_VAULT_PATH"] {
            return envPath
        }
        
        // Default fallback - adjust as needed
        let homeDir = FileManager.default.homeDirectoryForCurrentUser.path
        return "\(homeDir)/Projects/obsidian-vault"
    }
    
    private func openITermWithVaultSort() {
        guard let vaultPath = getVaultPath() else { 
            print("No vault path found!")
            return 
        }
        
        print("Opening iTerm with path: \(vaultPath)")
        
        let script = """
        tell application "iTerm"
            activate
            delay 0.5
            try
                -- Try to create tab in existing window
                tell current window
                    create tab with profile "ObsidianVault"
                    tell current session
                        write text "claude \\"/vault-content-processor\\""
                    end tell
                end tell
            on error
                -- No current window, create new one
                set newWindow to (create window with profile "ObsidianVault")
                tell current session of newWindow
                    write text "claude \\"/vault-content-processor\\""
                end tell
            end try
        end tell
        """
        
        print("Executing AppleScript...")
        let appleScript = NSAppleScript(source: script)
        var error: NSDictionary?
        let result = appleScript?.executeAndReturnError(&error)
        
        if let error = error {
            print("AppleScript error: \(error)")
        } else {
            print("AppleScript executed successfully: \(result?.stringValue ?? "no result")")
        }
    }
}

class VaultWatcher {
    private let vaultPath: String
    private let onCountChange: (Int) -> Void
    private var eventStream: FSEventStreamRef?
    private var timer: Timer?
    private var fileStates: [String: String] = [:]
    private var changedFiles: Set<String> = []
    private var lastClickTime: Date?
    private var lastClippingsCount = 0
    
    private let watchedDirectFiles = [
        "INBOX.md",
        "AI & Tools/Inbox.md", 
        "Articles, Posts & Videos/Inbox.md"
    ]
    
    init(vaultPath: String, onCountChange: @escaping (Int) -> Void) {
        self.vaultPath = vaultPath
        self.onCountChange = onCountChange
    }
    
    func start() {
        // Check if at least one watched file or clippings directory exists
        var foundFiles = false
        for file in watchedDirectFiles {
            let filePath = "\(vaultPath)/\(file)"
            if FileManager.default.fileExists(atPath: filePath) {
                foundFiles = true
                break
            }
        }
        
        // Also check if Clippings directory exists
        let clippingsPath = "\(vaultPath)/Clippings"
        if FileManager.default.fileExists(atPath: clippingsPath) {
            foundFiles = true
        }
        
        guard foundFiles else {
            print("No watched files or directories exist in: \(vaultPath)")
            return
        }
        
        var context = FSEventStreamContext(
            version: 0,
            info: Unmanaged.passUnretained(self).toOpaque(),
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        
        let callback: FSEventStreamCallback = { _, clientCallBackInfo, numEvents, eventPaths, eventFlags, eventIds in
            guard let clientCallBackInfo = clientCallBackInfo else { return }
            let watcher = Unmanaged<VaultWatcher>.fromOpaque(clientCallBackInfo).takeUnretainedValue()
            watcher.handleFileSystemEvent()
        }
        
        // Watch both vault root and clippings directory
        var pathsToWatch = [vaultPath]
        let clippingsDir = "\(vaultPath)/Clippings"
        if FileManager.default.fileExists(atPath: clippingsDir) {
            pathsToWatch.append(clippingsDir)
        }
        
        eventStream = FSEventStreamCreate(
            nil,
            callback,
            &context,
            pathsToWatch as CFArray,
            UInt64(kFSEventStreamEventIdSinceNow),
            0.1, // latency in seconds
            UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
        )
        
        guard let eventStream = eventStream else {
            print("Failed to create FSEventStream")
            return
        }
        
        FSEventStreamSetDispatchQueue(eventStream, DispatchQueue.global(qos: .background))
        FSEventStreamStart(eventStream)
        
        
        // Initial check - just set baseline states without triggering
        initializeStates()
    }
    
    func markAsSeen() {
        changedFiles.removeAll()
        lastClickTime = Date()
        
        // Persist click time across app restarts
        UserDefaults.standard.set(lastClickTime, forKey: "VaultWatcher.lastClickTime")
    }
    
    private func initializeStates() {
        // Set initial states without triggering badge
        for file in watchedDirectFiles {
            let filePath = "\(vaultPath)/\(file)"
            guard FileManager.default.fileExists(atPath: filePath) else { continue }
            
            do {
                let content = try String(contentsOfFile: filePath, encoding: .utf8)
                fileStates[file] = "\(content.count)-\(content.hash)"
            } catch {
                print("Error initializing \(file): \(error)")
            }
        }
        
        // Initialize clippings count and show immediately if > 0
        let clippingsPath = "\(vaultPath)/Clippings"
        print("Checking clippings path: \(clippingsPath)")
        if FileManager.default.fileExists(atPath: clippingsPath) {
            do {
                let allFiles = try FileManager.default.contentsOfDirectory(atPath: clippingsPath)
                print("Found files in Clippings: \(allFiles)")
                lastClippingsCount = allFiles.filter { $0.hasSuffix(".md") }.count
                print("Clippings .md count: \(lastClippingsCount)")
                
                // Show clippings count immediately - each file counts as one "change"
                for i in 0..<lastClippingsCount {
                    changedFiles.insert("Clippings-\(i)")
                }
                print("Added \(lastClippingsCount) Clippings to changed files, total count: \(changedFiles.count)")
                if changedFiles.count > 0 {
                    onCountChange(changedFiles.count)
                }
            } catch {
                print("Error initializing Clippings count: \(error)")
            }
        } else {
            print("Clippings directory does not exist")
        }
    }
    
    private func handleFileSystemEvent() {
        // Already on background queue from FSEventStreamSetDispatchQueue
        updateAllFiles()
    }
    
    private func updateAllFiles() {
        // Check direct files
        for file in watchedDirectFiles {
            let filePath = "\(vaultPath)/\(file)"
            
            guard FileManager.default.fileExists(atPath: filePath) else {
                continue
            }
            
            do {
                let content = try String(contentsOfFile: filePath, encoding: .utf8)
                let currentState = "\(content.count)-\(content.hash)"
                
                if fileStates[file] != currentState {
                    fileStates[file] = currentState
                    
                    // Don't trigger changes within 5 minutes of a click (but only if there was actually a click)
                    let inCooldown = lastClickTime != nil && Date().timeIntervalSince(lastClickTime!) < 300
                    if inCooldown {
                        continue
                    }
                    
                    changedFiles.insert(file)
                }
            } catch {
                print("Error reading \(file): \(error)")
            }
        }
        
        // Check for changes in Clippings directory (new .md files)
        let clippingsPath = "\(vaultPath)/Clippings"
        if FileManager.default.fileExists(atPath: clippingsPath) {
            do {
                let currentCount = try FileManager.default.contentsOfDirectory(atPath: clippingsPath)
                    .filter { $0.hasSuffix(".md") }.count
                
                if currentCount != lastClippingsCount {
                    lastClippingsCount = currentCount
                    
                    // Don't trigger within 5 minutes of a click (but only if there was actually a click)
                    let inCooldown = lastClickTime != nil && Date().timeIntervalSince(lastClickTime!) < 300
                    if !inCooldown {
                        // Clear old clippings entries and add new ones
                        changedFiles = Set(changedFiles.filter { !$0.hasPrefix("Clippings") })
                        for i in 0..<currentCount {
                            changedFiles.insert("Clippings-\(i)")
                        }
                    }
                }
                
            } catch {
                print("Error scanning Clippings directory: \(error)")
            }
        }
        
        // Update badge count
        print("Updating badge count to: \(changedFiles.count), changed files: \(changedFiles)")
        onCountChange(changedFiles.count)
    }
    
    private func countInboxItems(content: String) -> Int {
        // Count non-empty lines as potential items
        let lines = content.components(separatedBy: .newlines)
        let nonEmptyLines = lines.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        // If file has content, show at least 1
        return max(1, nonEmptyLines.count)
    }
    
    deinit {
        if let eventStream = eventStream {
            FSEventStreamStop(eventStream)
            FSEventStreamInvalidate(eventStream)
            FSEventStreamRelease(eventStream)
        }
    }
}