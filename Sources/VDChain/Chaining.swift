import Foundation

/// A type that provides [method chaining](https://en.wikipedia.org/wiki/Method_chaining) syntax and stores all the modifiers collected in the chain.
public protocol Chaining {
    
    associatedtype Root
    func apply(on root: inout Root) -> Void
}

extension Chaining {
    
    public subscript<A>(dynamicMember keyPath: KeyPath<Root, A>) -> PropertyChain<Self, A> {
        PropertyChain(self, getter: keyPath)
    }
}

#if swift(>=5.7)
#else
@dynamicMemberLookup
public struct AnyChaining<Root>: Chaining {
    
    var applier: (inout Root) -> Void
    
    public init<C: Chaining>(_ chaining: C) where C.Root == Root {
        self.init(chaining.apply)
    }
    
    public init(_ applier: @escaping (inout Root) -> Void) {
        self.applier = applier
    }
    
    public func apply(on root: inout Root) {
        applier(&root)
    }
}
#endif
