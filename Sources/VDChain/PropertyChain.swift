import Foundation

/// Helper type for chaining
@dynamicMemberLookup
public struct PropertyChain<Chain: ChainWrapper, Value> {

	public let chain: Chain
    public let getter: KeyPath<Chain.Base.Root, Value>

    public init(_ chain: Chain, getter: KeyPath<Chain.Base.Root, Value>) {
        self.chain = chain
		self.getter = getter
	}

    public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> PropertyChain<Chain, A> {
        PropertyChain<Chain, A>(chain, getter: getter.appending(path: keyPath))
	}

	public func callAsFunction(_ value: Value) -> Chain {
        guard let writable = getter as? WritableKeyPath<Chain.Base.Root, Value> else {
            return chain
        }
        return chain.set(writable, value)
	}
}

public extension PropertyChain {

	subscript<T, A>(dynamicMember keyPath: KeyPath<T, A>) -> PropertyChain<Chain, A?> where Value == T? {
		PropertyChain<Chain, A?>(chain, getter: getter.appending(path: \.[keyPath]))
	}

	subscript<T, A>(dynamicMember keyPath: WritableKeyPath<T, A?>) -> PropertyChain<Chain, A?> where Value == T? {
		PropertyChain<Chain, A?>(chain, getter: getter.appending(path: \.[writable: keyPath]))
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
}
