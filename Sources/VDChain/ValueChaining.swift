import Foundation

/// A type that provides chaining syntax for values.
public protocol ValueChaining<Root>: Chaining {

	var root: Root { get }
}

/// Creates a `Chain` instance
public postfix func ~ <C: ValueChaining>(_ lhs: Chain<C>) -> C.Root {
	lhs.apply()
}
