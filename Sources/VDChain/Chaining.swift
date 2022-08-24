import Foundation

/// A type that provides [method chaining](https://en.wikipedia.org/wiki/Method_chaining) syntax and stores all the modifiers collected in the chain.
public protocol Chaining {
    
    associatedtype Value
    var applier: (inout Value) -> Void { get set }
}

extension Chaining {

    /// Add a closure modifier to the chaining.
    ///
    /// - Parameter action: the modifier closure.
    /// - Returns: `Self`
    public func `do`(_ action: @escaping (inout Value) -> Void) -> Self {
        var result = self
        result.applier = { [applier] result in
            applier(&result)
            action(&result)
        }
        return result
    }

    public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> PropertyChain<Self, A> {
        PropertyChain(self, getter: keyPath)
    }
}
