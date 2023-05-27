import Foundation

/// Helper type for chaining
@dynamicMemberLookup
public struct PropertyChain<Base: Chaining, Value> {

	public let chaining: Base
	public let getter: KeyPath<Base.Root, Value>

	public init(_ value: Base, getter: KeyPath<Base.Root, Value>) {
		chaining = value
		self.getter = getter
	}

	public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> PropertyChain<Base, A> {
		PropertyChain<Base, A>(chaining, getter: getter.appending(path: keyPath))
	}

	public func callAsFunction(_ value: Value) -> Chain<KeyPathChain<Base, Value>> {
		KeyPathChain(chaining, keyPath: getter, value: value).wrap()
	}
}

public extension PropertyChain {

	subscript<T, A>(dynamicMember keyPath: KeyPath<T, A>) -> PropertyChain<Base, A?> where Value == T? {
		PropertyChain<Base, A?>(chaining, getter: getter.appending(path: \.[keyPath]))
	}

	subscript<T, A>(dynamicMember keyPath: WritableKeyPath<T, A?>) -> PropertyChain<Base, A?> where Value == T? {
		PropertyChain<Base, A?>(chaining, getter: getter.appending(path: \.[writable: keyPath]))
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
