import Foundation

public protocol Chainable {
    
    associatedtype Chain: Chaining = EmptyChaining<Self>
    var chain: VDChain.Chain<Chain> { get }
}

extension Chainable where Chain == EmptyChaining<Self> {
    
    public var chain: VDChain.Chain<Chain> {
        EmptyChaining(self).wrap()
    }
}

public protocol ChainableType {
    
    associatedtype TypeChain: Chaining = VDChain.TypeChain<Self>
    static var chain: Chain<TypeChain> { get }
}

extension ChainableType where TypeChain == VDChain.TypeChain<Self> {
    
    public static var chain: VDChain.Chain<TypeChain> {
        TypeChain().wrap()
    }
}
