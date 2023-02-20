// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Alltrack",
    products: [
        .library(name: "Alltrack", targets: ["Alltrack"]),
        .library(name: "Sociomantic", targets: ["Sociomantic", "Alltrack"]),
        .library(name: "Criteo", targets: ["Criteo", "Alltrack"]),
        .library(name: "Trademob", targets: ["Trademob", "Alltrack"]),
        .library(name: "WebBridge", targets: ["WebBridge", "Alltrack"])
    ],
    targets: [
        .target(
            name: "Alltrack",
            path: "Alltrack",
            exclude: ["Info.plist"],
            cSettings: [
                .headerSearchPath(""),
                .headerSearchPath("ALTAdditions")
            ]
        ),
        .target(
            name: "Sociomantic",
            path: "plugin/Sociomantic",
            exclude: ["Alltrack"],
            publicHeadersPath: "",
            cSettings: [
                .headerSearchPath("Alltrack"),
                .headerSearchPath("Alltrack/ALTAdditions")
            ]
        ),
        .target(
            name: "Criteo",
            path: "plugin/Criteo",
            exclude: ["Alltrack"],
            publicHeadersPath: "",
            cSettings: [
                .headerSearchPath("Alltrack"),
                .headerSearchPath("Alltrack/ALTAdditions")
            ]
        ),
        .target(
            name: "Trademob",
            path: "plugin/Trademob",
            exclude: ["Alltrack"],
            publicHeadersPath: "",
            cSettings: [
                .headerSearchPath("Alltrack"),
                .headerSearchPath("Alltrack/ALTAdditions")
            ]
        ),
        .target(
            name: "WebBridge",
            path: "AlltrackBridge",
            exclude: ["Alltrack"],
            cSettings: [
                .headerSearchPath(""),
                .headerSearchPath("WebViewJavascriptBridge"),
                .headerSearchPath("Alltrack"),
            ]
        ),
    ]
)
