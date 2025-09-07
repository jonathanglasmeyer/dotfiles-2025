# Obsidian Vault Sorter - Development Workflow

## Overview
Native macOS menubar application that monitors `Projects/obsidian-vault/INBOX.md` and provides one-click access to Claude vault processing.

## Architecture
- **Swift App**: `/Sources/ObsidianVaultSorter/main.swift` - Main menubar application
- **Build Script**: `~/.local/bin/build-vault-sorter` - Automated build/deploy pipeline
- **LaunchAgent**: `~/Library/LaunchAgents/com.local.obsidianvaultsorter.plist` - Auto-start service
- **Test Script**: `~/.local/bin/vault-click` - Manual testing of iTerm integration

## Development Workflow

### When Swift Code Changes (main.swift)
**IMPORTANT**: Claude cannot execute the build script due to sudo requirement.

1. Claude makes changes to `Sources/ObsidianVaultSorter/main.swift`
2. **User must manually run**: `~/.local/bin/build-vault-sorter`
3. Enter sudo password when prompted for code signing
4. App automatically rebuilds, signs, and restarts

### When Scripts Change (vault-click, etc.)
- Claude can directly edit and test these scripts
- No rebuild required, changes are immediate

### Testing
- **Manual click test**: `~/.local/bin/vault-click`
- **Check service status**: `launchctl list | grep obsidianvaultsorter`
- **View logs**: Check Console.app for crash logs if needed

### iTerm Integration
- Uses existing "ObsidianVault" iTerm profile (pre-configured with correct working directory)
- Sends command: `claude "/vault-content-processor"`
- No cd command needed since profile handles working directory

## Troubleshooting
- If menubar icon disappears: Check LaunchAgent status
- If clicks don't work: Test with `vault-click` script first
- If app crashes on start: Usually code signing issue, run build script again

## Reminder for Claude
🚨 **ALWAYS remind user to run `~/.local/bin/build-vault-sorter` after making any changes to Swift code (main.swift)**

After editing Swift code, Claude must tell the user:
"Please run: `~/.local/bin/build-vault-sorter` and enter your sudo password when prompted."