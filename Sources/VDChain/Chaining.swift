import Foundation

/// A type that provides [method chaining](https://en.wikipedia.org/wiki/Method_chaining) syntax and stores all the modifiers collected in the chain.
public protocol Chaining<Root> {

	associatedtype Root
    
    func set<T>(_ keyPath: WritableKeyPath<Root, T>, _ value: T) -> Chain<Self>
}

public extension Chaining {
    
    func set<T>(_ keyPath: WritableKeyPath<Root, T>, _ value: T) -> Chain<Self> {
        wrap().do { root in
            root[keyPath: keyPath] = value
        }
    }
}
