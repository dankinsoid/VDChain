import Foundation

public protocol ConsistentChaining<Root>: Chaining {
    
    associatedtype AllValues
    func getAllValues(for root: Root) -> AllValues
    func applyAllValues(_ values: AllValues, for root: inout Root)
}

#if swift(>=5.7)
#else
public struct AnyConsistentChaining<Root, AllValues>: ConsistentChaining {
    
    var applier: (inout Root) -> Void
    var getter: (Root) -> AllValues
    var setter: (AllValues, inout Root) -> Void
    
    public init<C: ConsistentChaining>(_ chaining: C) where C.Root == Root, C.AllValues == AllValues {
        self.init(applier: chaining.apply, getter: chaining.getAllValues, setter: chaining.applyAllValues)
    }
    
    public init(
        applier: @escaping (inout Root) -> Void,
        getter: @escaping (Root) -> AllValues,
        setter: @escaping (AllValues, inout Root) -> Void
    ) {
        self.applier = applier
        self.getter = getter
        self.setter = setter
    }
    
    public func apply(on root: inout Root) {
        applier(&root)
    }
    
    public func getAllValues(for root: Root) -> AllValues {
        getter(root)
    }
    
    public func applyAllValues(_ values: AllValues, for root: inout Root) {
        setter(values, &root)
    }
}

extension ConsistentChaining {
    
    public func any() -> AnyConsistentChaining<Root, AllValues> {
        AnyConsistentChaining(self)
    }
}
#endif
