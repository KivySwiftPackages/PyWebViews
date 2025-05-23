// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "PyWebViews",
	platforms: [.iOS(.v13)],
	products: [
		.library(name: "PyWebViews", targets: ["PyWebViews"])
	],
	dependencies: [
		.package(url: "https://github.com/KivySwiftLink/PythonCore", .upToNextMajor(from: .init(311, 0, 0))),
        .package(url: "https://github.com/KivySwiftLink/PySwiftKit", from: .init(311, 0, 0)),
        //.package(url: "https://github.com/KivySwiftLink/SwiftonizePlugin", from: .init(0, 0, 0)),
		//.package(path: "../KivyTex"),
		//.package(path: "/Volumes/CodeSSD/GitHub/UIViewRender"),
		.package(url: "https://github.com/KivySwiftPackages/UIViewRender", .upToNextMajor(from: .init(311, 0, 0))),
		.package(url: "https://github.com/KivySwiftPackages/KivyTexture", .upToNextMajor(from: .init(311, 0, 0))),
		
		//.package(path: "../SwiftonizePlugin")
		.package(url: "https://github.com/PythonSwiftLink/SwiftonizePlugin", .upToNextMajor(from: .init(0, 0, 0)))
	],
	targets: [
		.target(
			name: "PyWebViews",
			dependencies: [
				.product(name: "PySwiftCore", package: "PySwiftKit"),
				.product(name: "PyUnpack", package: "PySwiftKit"),
				.product(name: "PyCallable", package: "PySwiftKit"),
				.product(name: "PySerializing", package: "PySwiftKit"),
				.product(name: "PyDictionary", package: "PySwiftKit"),
				.product(name: "PythonCore", package: "PythonCore"),
				
				.product(name: "UIViewRender", package: "UIViewRender"),
				.product(name: "KivyTexture", package: "KivyTexture"),
				
			],
			plugins: [ .plugin(name: "Swiftonize", package: "SwiftonizePlugin") ]
		),

	]
)
