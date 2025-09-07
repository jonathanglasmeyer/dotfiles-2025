// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ObsidianVaultSorter",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "ObsidianVaultSorter", targets: ["ObsidianVaultSorter"])
    ],
    targets: [
        .executableTarget(
            name: "ObsidianVaultSorter",
            dependencies: []
        )
    ]
)