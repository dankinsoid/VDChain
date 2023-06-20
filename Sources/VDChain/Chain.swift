import Foundation

public protocol ChainWrapper<Base> {
    
    associatedtype Base: Chaining
    
    func set<T>(_ keyPath: WritableKeyPath<Base.Root, T>, _ value: T) -> Self
}

@dynamicMemberLookup
public struct Chain<Base: Chaining>: ChainWrapper {

	public var base: Base
    public private(set) var values: ChainValues<Base.Root> = ChainValues()

	public init(_ base: Base) {
		self.base = base
	}

    public subscript<A>(dynamicMember keyPath: KeyPath<Base.Root, A>) -> PropertyChain<Self, A> {
		PropertyChain(self, getter: keyPath)
	}
    
    /// Set value with keypath
    ///
    public func set<T>(_ keyPath: WritableKeyPath<Base.Root, T>, _ value: T) -> Chain<Base> {
        var result = self
        let apply = result.base.set(keyPath, value, values: result.values)
        return result.do(apply)
    }
    
    public func reduce<T>(_ keyPath: WritableKeyPath<ChainValues<Base.Root>, T>, _ value: (T) -> T) -> Chain {
        var result = self
        result.values[keyPath: keyPath] = value(result.values[keyPath: keyPath])
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
            { root in
                apply(&root)
                action(&root)
            }
        }
	}
}

public extension Chaining {

	func wrap() -> Chain<Self> {
		Chain(self)
	}
}

public extension Chain {
    
    /// Apply the chaining
    func apply(on value: inout Base.Root) {
        values.apply(&value)
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
