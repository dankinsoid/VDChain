import Foundation

/// A type that provides [method chaining](https://en.wikipedia.org/wiki/Method_chaining) syntax and stores all the modifiers collected in the chain.
public protocol Chaining<Root> {

	associatedtype Root
    
    mutating func set<T>(_ keyPath: WritableKeyPath<Root, T>, _ value: T, values: ChainValues<Root>) -> (inout Root) -> Void
}

public extension Chaining {
    
    mutating func set<T>(_ keyPath: WritableKeyPath<Root, T>, _ value: T, values: ChainValues<Root>) -> (inout Root) -> Void {
        { root in
            root[keyPath: keyPath] = value
        }
    }
}
