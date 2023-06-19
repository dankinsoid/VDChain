import Foundation

@dynamicMemberLookup
public struct Chain<Base: Chaining> {

	public var base: Base
    public private(set) var values: ChainValues<Base.Root> = ChainValues()

	public init(_ base: Base) {
		self.base = base
	}

	public subscript<A>(dynamicMember keyPath: KeyPath<Base.Root, A>) -> PropertyChain<Base, A> {
		PropertyChain(self, getter: keyPath)
	}
    
    public func reduce<T>(_ keyPath: WritableKeyPath<ChainValues<Base.Root>, T>, _ value: (inout T) -> Void) -> Chain {
        var result = self
        value(&result.values[keyPath: keyPath])
        return result
    }
    
    public func modifier<C: Chaining<Base.Root>>(_ modifier: Chain<C>) -> Chain<Base> {
        var result = self
        result.values.merge(modifier.values)
        return result
    }
}

public extension Chain {

	/// Add a closure modifier to the chaining.
	///
	/// - Parameter action: the modifier closure.
	/// - Returns: `Self`
	func `do`(_ action: @escaping (inout Base.Root) -> Void) -> Chain<Base> {
        reduce(\.apply) { apply in
            apply = { [apply] root in
                apply(&root)
                action(&root)
            }
        }
	}

	/// Set value with keypath
	///
	/// - Parameter action: the modifier closure.
	/// - Returns: `Self`
	func set<T>(_ keyPath: WritableKeyPath<Base.Root, T>, _ value: T) -> Chain<Base> {
        self.do { root in
            root[keyPath: keyPath] = value
        }
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
		values.apply(&result)
		return result
	}
}
