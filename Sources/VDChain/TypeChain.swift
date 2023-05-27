import Foundation

/**
 Wrapper that provides `method chaining` syntax for any type.

  Usage example:
 ```
 let modifier = UILabel.chain.text("Some Text").textColor(.blue).any()

 modifier.apply(
 ```
  */
public struct TypeChain<Root>: ConsistentChaining, KeyPathChaining {

	public let values: [PartialKeyPath<Root>: Any] = [:]

	public init() {}

	public func apply(on root: inout Root) {}

	public func getAllValues(for root: Root) {
		()
	}

	public func applyAllValues(_ values: Void, for root: inout Root) {}
}

public postfix func ~ <T>(_: T.Type) -> Chain<TypeChain<T>> {
	TypeChain().wrap()
}

public extension NSObjectProtocol {

	static var chain: Chain<TypeChain<Self>> {
		TypeChain().wrap()
	}
}
