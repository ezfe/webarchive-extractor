// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "WebArchiveExtractor",
	platforms: [
		.macOS(.v14),
	],
	products: [
		.library(name: "WebArchiveExtractor", targets: ["WebArchiveExtractor"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.executableTarget(
			name: "webarchive-cli",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.target(name: "WebArchiveExtractor"),
			]
		),
		.target(name: "WebArchiveExtractor"),
	]
)
