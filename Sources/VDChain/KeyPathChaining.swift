import Foundation

public protocol KeyPathChaining<Root>: ConsistentChaining {

	var values: [PartialKeyPath<Root>: Any] { get }
}

public struct KeyPathChain<Base: Chaining, Value>: Chaining {

	public var base: Base
	public var keyPath: KeyPath<Base.Root, Value>
	public var value: Value

	public init(_ base: Base, keyPath: KeyPath<Base.Root, Value>, value: Value) {
		self.base = base
		self.keyPath = keyPath
		self.value = value
	}

	public func apply(on root: inout Base.Root) {
		base.apply(on: &root)
		apply(value: value, on: &root)
	}

	private func apply(value: Value, on root: inout Base.Root) {
		guard let writable = keyPath as? WritableKeyPath<Base.Root, Value> else {
			return
		}
		root[keyPath: writable] = value
	}
}

extension KeyPathChain: ValueChaining where Base: ValueChaining {

	public var root: Base.Root {
		base.root
	}
}

extension KeyPathChain: ConsistentChaining where Base: ConsistentChaining {

	public typealias AllValues = (Base.AllValues, Value)

	public func getAllValues(for root: Base.Root) -> AllValues {
		(base.getAllValues(for: root), root[keyPath: keyPath])
	}

	public func applyAllValues(_ values: AllValues, for root: inout Base.Root) {
		base.applyAllValues(values.0, for: &root)
		apply(value: values.1, on: &root)
	}
}

extension KeyPathChain: KeyPathChaining where Base: KeyPathChaining {

	public var values: [PartialKeyPath<Base.Root>: Any] {
		base.values.merging([keyPath: value]) { _, p in p }
	}
}
