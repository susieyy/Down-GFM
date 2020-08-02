// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Down",
    platforms: [
        .macOS("10.11"),
        .iOS("9.0"),
        .tvOS("9.0")
    ],
    products: [
        .library(
            name: "Down",
            targets: ["Down"]
        )
    ],
    dependencies: [
        .package(name: "libcmark_gfm", url: "https://github.com/KristopherGBaker/libcmark_gfm.git", from: "0.29.3")
    ],    
    targets: [
        .target(
            name: "Down",
            dependencies: ["libcmark_gfm"],
            path: "Source/",
            exclude: ["Down.h"]
        ),
        .testTarget(
            name: "DownTests",
            dependencies: ["Down"],
            path: "Tests/",
            exclude: [
                "AST/VisitorTests.swift",
                "DownViewTests.swift",
                "Fixtures",
                "Styler/BlockQuoteStyleTests.swift",
                "Styler/CodeBlockStyleTests.swift",
                "Styler/DownDebugLayoutManagerTests.swift",
                "Styler/HeadingStyleTests.swift",
                "Styler/LinkStyleTests.swift",
                "Styler/InlineStyleTests.swift",
                "Styler/ListItemStyleTests.swift",
                "Styler/StylerTestSuite.swift",
                "Styler/ThematicBreakSyleTests.swift"
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
