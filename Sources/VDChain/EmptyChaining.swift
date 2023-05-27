import Foundation

/**
  Wrapper that provides `method chaining` syntax for any value.

  Usage example:
 ```
 let label = UILabel()~
                 .text("Some Text")
                 .textColor(.blue)
                 .apply()
 ```
  */
public struct EmptyChaining<Root>: ValueChaining, ConsistentChaining, KeyPathChaining {

	/// value to modify
	public var root: Root
	public let values: [PartialKeyPath<Root>: Any] = [:]

	/// Initialization
	///
	/// - Parameter value: the value to modify
	public init(_ root: Root) {
		self.root = root
	}

	public func apply(on root: inout Root) {}

	public func getAllValues(for root: Root) {
		()
	}

	public func applyAllValues(_ values: Void, for root: inout Root) {}
}

postfix operator ~

/// Creates a `Chain` instance
public postfix func ~ <Root>(_ lhs: Root) -> Chain<EmptyChaining<Root>> {
	EmptyChaining(lhs).wrap()
}

public extension NSObjectProtocol {

	var chain: Chain<EmptyChaining<Self>> {
		EmptyChaining(self).wrap()
	}
}
