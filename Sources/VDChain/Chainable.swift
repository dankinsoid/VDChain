import Foundation

public protocol Chainable {

	associatedtype Chain: Chaining = EmptyChaining<Self>
	associatedtype TypeChain: Chaining = VDChain.TypeChain<Self>
	static var chain: VDChain.Chain<TypeChain> { get }
	var chain: VDChain.Chain<Chain> { get }
}

public extension Chainable where Chain == EmptyChaining<Self> {

	var chain: VDChain.Chain<Chain> {
		EmptyChaining(self).wrap()
	}
}

public extension Chainable where TypeChain == VDChain.TypeChain<Self> {

	static var chain: VDChain.Chain<TypeChain> {
		TypeChain().wrap()
	}
}
