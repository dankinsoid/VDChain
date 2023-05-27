import Foundation

/// A type that provides [method chaining](https://en.wikipedia.org/wiki/Method_chaining) syntax and stores all the modifiers collected in the chain.
public protocol Chaining<Root> {

	associatedtype Root
	func apply(on root: inout Root) -> Void
}

#if swift(>=5.7)
#else
public struct AnyChaining<Root>: Chaining {

	var applier: (inout Root) -> Void

	public init<C: Chaining>(_ chaining: C) where C.Root == Root {
		self.init(chaining.apply)
	}

	public init(_ applier: @escaping (inout Root) -> Void) {
		self.applier = applier
	}

	public func apply(on root: inout Root) {
		applier(&root)
	}
}

public extension Chaining {

	func any() -> AnyChaining<Root> {
		AnyChaining(self)
	}
}
#endif
