import Foundation

/// Helper type for chaining
@dynamicMemberLookup
public struct PropertyChain<Chain: ChainWrapper, Value> {

	public let chain: Chain
    public let getter: WritableKeyPath<Chain.Base.Root, Value>

    public init(_ chain: Chain, getter: WritableKeyPath<Chain.Base.Root, Value>) {
        self.chain = chain
		self.getter = getter
	}

    @_disfavoredOverload
    public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> ImmutablePropertyChain<Chain, A> {
        ImmutablePropertyChain<Chain, A>(chain, getter: getter.appending(path: keyPath))
	}
    
    public subscript<A>(dynamicMember keyPath: WritableKeyPath<Value, A>) -> PropertyChain<Chain, A> {
        PropertyChain<Chain, A>(chain, getter: getter.appending(path: keyPath))
    }

	public func callAsFunction(_ value: Value) -> Chain {
        chain.set(getter, value)
	}
}

public extension PropertyChain {

    @_disfavoredOverload
	subscript<T, A>(dynamicMember keyPath: KeyPath<T, A>) -> ImmutablePropertyChain<Chain, A?> where Value == T? {
        ImmutablePropertyChain<Chain, A?>(chain, getter: getter.appending(path: \.[keyPath]))
	}
    
	subscript<T, A>(dynamicMember keyPath: WritableKeyPath<T, A?>) -> PropertyChain<Chain, A?> where Value == T? {
		PropertyChain<Chain, A?>(chain, getter: getter.appending(path: \.[writable: keyPath]))
	}
}

public extension PropertyChain {
    
    func or<T: Hashable>(_ value: T) -> PropertyChain<Chain, T> where T? == Value {
        PropertyChain<Chain, T>(chain, getter: getter.appending(path: \.[or: value]))
    }
}

/// Helper type for chaining
@dynamicMemberLookup
public struct ImmutablePropertyChain<Chain: ChainWrapper, Value> {
    
    public let chain: Chain
    public let getter: KeyPath<Chain.Base.Root, Value>
    
    public init(_ chain: Chain, getter: KeyPath<Chain.Base.Root, Value>) {
        self.chain = chain
        self.getter = getter
    }
    
    @_disfavoredOverload
    public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> ImmutablePropertyChain<Chain, A> {
        ImmutablePropertyChain<Chain, A>(chain, getter: getter.appending(path: keyPath))
    }
    
    public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, A>) -> PropertyChain<Chain, A> {
        PropertyChain<Chain, A>(chain, getter: getter.appending(path: keyPath))
    }
}

public extension ImmutablePropertyChain {
    
    @_disfavoredOverload
    subscript<T, A>(dynamicMember keyPath: KeyPath<T, A>) -> ImmutablePropertyChain<Chain, A?> where Value == T? {
        ImmutablePropertyChain<Chain, A?>(chain, getter: getter.appending(path: \.[keyPath]))
    }
    
    subscript<T, A>(dynamicMember keyPath: ReferenceWritableKeyPath<T, A?>) -> PropertyChain<Chain, A?> where Value == T? {
        PropertyChain<Chain, A?>(chain, getter: getter.appending(path: \.[ref: keyPath]))
    }
}

public extension ImmutablePropertyChain {
    
    func or<T: Hashable>(_ value: T) -> ImmutablePropertyChain<Chain, T> where T? == Value {
        ImmutablePropertyChain<Chain, T>(chain, getter: getter.appending(path: \.[or: value]))
    }
}

private extension Optional {

	subscript<B>(_ keyPath: KeyPath<Wrapped, B>) -> B? {
		self?[keyPath: keyPath]
	}

	subscript<B>(writable keyPath: WritableKeyPath<Wrapped, B?>) -> B? {
		get {
			self?[keyPath: keyPath]
		}
		set {
			if let value = newValue {
				self?[keyPath: keyPath] = value
			} else {
				self?[keyPath: keyPath] = .none
			}
		}
	}
    
    subscript<B>(ref keyPath: ReferenceWritableKeyPath<Wrapped, B?>) -> B? {
        get {
            self?[keyPath: keyPath]
        }
        nonmutating set {
            if let value = newValue {
                self?[keyPath: keyPath] = value
            } else {
                self?[keyPath: keyPath] = .none
            }
        }
    }
    
    subscript(or value: Wrapped) -> Wrapped {
        get {
            self ?? value
        }
        set {
            self = value
        }
    }
}
