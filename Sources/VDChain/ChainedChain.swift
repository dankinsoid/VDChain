import Foundation

public struct ChainedChain<Base: Chaining, Value>: Chaining {
    
    public var base: Base
    public var value: Value
    public var getter: (Base.Root) -> Value
    public var setter: (Value, inout Base.Root) -> Void
    
    public init(base: Base, value: Value, get: @escaping (Base.Root) -> Value, set: @escaping (Value, inout Base.Root) -> Void) {
        self.base = base
        self.value = value
        self.getter = get
        self.setter = set
    }
    
    public func apply(on root: inout Base.Root) {
        base.apply(on: &root)
        setter(value, &root)
    }
}

extension ChainedChain: ValueChaining where Base: ValueChaining {
    
    public var root: Base.Root {
        base.root
    }
}

extension ChainedChain: ConsistentChaining where Base: ConsistentChaining {
    
    public typealias AllValues = (Base.AllValues, Value)
    
    public func getAllValues(for root: Base.Root) -> AllValues {
        (base.getAllValues(for: root), getter(root))
    }
    
    public func applyAllValues(_ values: AllValues, for root: inout Base.Root) {
        base.applyAllValues(values.0, for: &root)
        setter(values.1, &root)
    }
}
