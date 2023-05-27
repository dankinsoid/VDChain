# VDChain
[![Version](https://img.shields.io/cocoapods/v/VDChain.svg?style=flat)](https://cocoapods.org/pods/VDChain)
[![License](https://img.shields.io/cocoapods/l/VDChain.svg?style=flat)](https://cocoapods.org/pods/VDChain)
[![Platform](https://img.shields.io/cocoapods/p/VDChain.svg?style=flat)](https://cocoapods.org/pods/VDChain)

 VDChain is a Swift library that harnesses the power of `@dynamicMemberLookup`, `KeyPath`, and `callAsFunction` to enable function chaining. This simplifies the modification of objects, allowing for cleaner and more concise code.

## Features

- Intuitive syntax for object modification
- Improved readability and maintainability of Swift code
- Great for both beginners and advanced Swift developers

## Requirements

- Swift 5.1+
- iOS 11.0+
- macOS 10.13+

## Usage

Start by importing SwiftChain in the files where you want to use it:

```swift
import VDChain
```

You can then use function chaining to modify your objects. For example:

```swift
let label = UILabel().chain
  .text("Text")
  .textColor(.red)
  .font(.system(24))
  .apply()
```

In this example, `UILabel` properties `text`, `textColor`, and `font` are set through function chaining.

## Chain Creation

There are three methods you can use to create a chain with VDChain:

1. **Using the `.chain` property**: VDChain provides the `.chain` property on any `NSObject` type. You can also add this property to your own types by implementing the `Chainable` protocol. This protocol provides both static and instance properties, allowing you to call `.chain` on your types directly.

   ```swift
   let label = UILabel().chain
     .text("Hello, World!")
     .textColor(.red)
     .apply()
   ```

2. **Using the postfix operator `~`**: You can also create a chain using the `~` operator. This is a shorthand way to begin a chain on any value without calling the `.chain` property or implementing `Chainable` protocol.

   ```swift
   let button = UIButton()~
     .title("Click me")
     .titleColor(.blue)
     .apply()
   ```

3. **Using `EmptyChaining` or `TypeChaining`**: You can create an empty chain using the `EmptyChaining` class.

   ```swift
   let view = EmptyChaining(self).wrap()
     .backgroundColor(.green)
     .apply()
   ```

Every chain method returns a `Chain<...>` object. To retrieve the original object from the chain, simply end your chain with the `apply()` method.

### Type and Instance Chaining

VDChain supports chaining on both types and instances. You can define a chain of methods on a type and later use this chain on an instance of that type:

```swift
// Create a chain on the UILabel type that sets the text color to black
let blackColorModifier = UILabel.chain
  .textColor(.black)
  .apply()

// Use the chain on an instance of UILabel
let label = UILabel().chain
  .modifier(blackColorModifier)
  .apply()
```

This allows you to define complex chains of modifications at the type level and easily apply them to instances as needed.

## Real-world Usage Example

To see VDChain in action, check out my other library, [VDLayout](https://github.com/dankinsoid/VDLayout).

## Installation
1. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/VDChain.git", from: "2.7.2")
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
