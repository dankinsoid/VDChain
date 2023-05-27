# VDChain

[![CI Status](https://img.shields.io/travis/dankinsoid/VDChain.svg?style=flat)](https://travis-ci.org/dankinsoid/VDChain)
[![Version](https://img.shields.io/cocoapods/v/VDChain.svg?style=flat)](https://cocoapods.org/pods/VDChain)
[![License](https://img.shields.io/cocoapods/l/VDChain.svg?style=flat)](https://cocoapods.org/pods/VDChain)
[![Platform](https://img.shields.io/cocoapods/p/VDChain.svg?style=flat)](https://cocoapods.org/pods/VDChain)


## Description
Combination of [`@dynamicMemberLookup`](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html) with `KeyPath`es and `callAsFunction`
```swift
let label = UILabel().chain
  .text("Text")
  .textColor(.red)
  .font(.system(24))
  .apply()
```

## Installation
1. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/VDChain.git", from: "2.7.0")
  ],
  targets: [
    .target(name: "SomeProject", dependencies: ["VDChain"])
  ]
)
```
```ruby
$ swift build
```

2.  [CocoaPods](https://cocoapods.org)

Add the following line to your Podfile:
```ruby
pod 'VDChain'
```
and run `pod update` from the podfile directory first.

## Author

dankinsoid, voidilov@gmail.com

## License

VDChain is available under the MIT license. See the LICENSE file for more info.

