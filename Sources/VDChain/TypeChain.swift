import Foundation

/**
 Wrapper that provides `method chaining` syntax for any type.

  Usage example:
 ```
 let modifier = UILabel.chain.text("Some Text").textColor(.blue).any()

 modifier.apply(
 ```
  */
public struct TypeChain<Root>: Chaining {
    
	public init() {}
}

public postfix func ~ <T>(_: T.Type) -> Chain<TypeChain<T>> {
	TypeChain().wrap()
}

public extension NSObjectProtocol {

	static var chain: Chain<TypeChain<Self>> {
		TypeChain().wrap()
	}
}
