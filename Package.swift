// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "xlsxwriter.swift",
  products: [
    .library(name: "Cminizip", targets: ["Cminizip"]),
    .library(name: "xlsxwriter", targets: ["xlsxwriter"]),
  ],
  dependencies: [],
  targets: [
    .target(name: "xlsxwriter", dependencies: ["Cxlsxwriter"]), 
    .target(name: "Cxlsxwriter", dependencies: ["Cmd5", "Ctmpfileplus", "Cminizip"]),
    .target(name: "Cminizip"),
    .target(name: "Ctmpfileplus"), .target(name: "Cmd5"),
    .testTarget(name: "xlsxwriterTests", dependencies: ["xlsxwriter"]),
  ]
)

if let xlsxwriter = package.targets.first(where: { $0.name == "Cxlsxwriter" }) {
  #if os(Windows)
  xlsxwriter.linkerSettings = [.linkedLibrary("zlibstatic.lib")]
  package.targets.filter { $0.name.hasPrefix("C") }
    .forEach { $0.cxxSettings = [.define("_CRT_SECURE_NO_WARNINGS")] }
  #else
  xlsxwriter.linkerSettings = [.linkedLibrary("z")]
  #endif
}

if let minizip = package.targets.first(where: { $0.name == "Cminizip" }) {
  #if os(Windows)
  minizip.linkerSettings = [.linkedLibrary("zlibstatic.lib")]
  #else
  minizip.linkerSettings = [.linkedLibrary("z")]
  #endif
}
