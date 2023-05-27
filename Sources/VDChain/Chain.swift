import Foundation

@dynamicMemberLookup
public struct Chain<Base: Chaining> {

	public var base: Base

	public init(_ base: Base) {
		self.base = base
	}

	public subscript<A>(dynamicMember keyPath: KeyPath<Base.Root, A>) -> PropertyChain<Base, A> {
		PropertyChain(base, getter: keyPath)
	}

	public func modifier<C: Chaining>(_ modifier: C) -> Chain<ModifierChain<Base, C>> {
		ModifierChain(base: base, modifier: modifier).wrap()
	}

	#if swift(>=5.7)
	#else
	public func any() -> AnyChaining<Base.Root> {
		base.any()
	}
	#endif
}

public extension Chain {

	/// Add a closure modifier to the chaining.
	///
	/// - Parameter action: the modifier closure.
	/// - Returns: `Self`
	func `do`(_ action: @escaping (inout Base.Root) -> Void) -> Chain<DoChain<Base>> {
		DoChain(base: base, action: action).wrap()
	}

	/// Set value with keypath
	///
	/// - Parameter action: the modifier closure.
	/// - Returns: `Self`
	func set<T>(_ keyPath: WritableKeyPath<Base.Root, T>, _ value: T) -> Chain<KeyPathChain<Base, T>> {
		KeyPathChain(base, keyPath: keyPath, value: value).wrap()
	}
}

public extension Chaining {

	func wrap() -> Chain<Self> {
		Chain(self)
	}
}

public extension Chain where Base: ValueChaining {

	/// Apply the chaining
	@discardableResult
	func apply() -> Base.Root {
		var result = base.root
		base.apply(on: &result)
		return result
	}
}
