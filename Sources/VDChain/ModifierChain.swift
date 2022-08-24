import Foundation

@dynamicMemberLookup
public struct ModifierChain<Base: Chaining, Modifier: Chaining>: Chaining where Modifier.Root == Base.Root {
    
    public var base: Base
    public var modifier: Modifier
    
    public func apply(on root: inout Base.Root) {
        base.apply(on: &root)
        modifier.apply(on: &root)
    }
    
    public init(base: Base, modifier: Modifier) {
        self.base = base
        self.modifier = modifier
    }
}

extension ModifierChain: ValueChaining where Base: ValueChaining {
    
    public var root: Base.Root {
        base.root
    }
}

extension ModifierChain: ConsistentChaining where Base: ConsistentChaining, Modifier: ConsistentChaining {
    
    public typealias AllValues = (Base.AllValues, Modifier.AllValues)
    
    public func applyAllValues(_ values: AllValues, for root: inout Base.Root) {
        base.applyAllValues(values.0, for: &root)
        modifier.applyAllValues(values.1, for: &root)
    }
    
    public func getAllValues(for root: Base.Root) -> AllValues {
        (base.getAllValues(for: root), modifier.getAllValues(for: root))
    }
}

extension Chaining {
    
    
    public func modifier<C: Chaining>(_ chain: C) -> ModifierChain<Self, C> {
        ModifierChain(base: self, modifier: chain)
    }
}
