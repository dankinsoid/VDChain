import Foundation

/// A type that provides chaining syntax for values.
public protocol ValueChaining: Chaining {
    
    var root: Root { get }
}

#if swift(>=5.7)
#else
public struct AnyValueChaining<Root>: ValueChaining {
    
    public var root: Root
    var applier: (inout Root) -> Void
    
    public init<C: ValueChaining>(_ chaining: C) where C.Root == Root {
        self.init(chaining.root, applier: chaining.apply)
    }
    
    public init(_ root: Root, applier: @escaping (inout Root) -> Void) {
        self.root = root
        self.applier = applier
    }
    
    public func apply(on root: inout Root) {
        applier(&root)
    }
}

extension ValueChaining {
    
    public func any() -> AnyValueChaining<Root> {
        AnyValueChaining(self)
    }
}
#endif

///Creates a `Chain` instance
public postfix func ~<C: ValueChaining>(_ lhs: Chain<C>) -> C.Root {
    lhs.apply()
}
