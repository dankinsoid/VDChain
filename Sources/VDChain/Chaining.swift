import Foundation

/// A type that provides [method chaining](https://en.wikipedia.org/wiki/Method_chaining) syntax and stores all the modifiers collected in the chain.
public protocol Chaining<Root> {

	associatedtype Root
}
