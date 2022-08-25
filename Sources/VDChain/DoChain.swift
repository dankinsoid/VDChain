import Foundation

public struct DoChain<Base: Chaining>: Chaining {
    
    public var action: (inout Base.Root) -> Void
    public var base: Base
    
    public func apply(on value: inout Base.Root) {
        base.apply(on: &value)
        action(&value)
    }
    
    public init(base: Base, action: @escaping (inout Base.Root) -> Void) {
        self.action = action
        self.base = base
    }
}

extension DoChain: ValueChaining where Base: ValueChaining {
    
    public var root: Base.Root {
        base.root
    }
}

extension Chaining {
    
    /// Add a closure modifier to the chaining.
    ///
    /// - Parameter action: the modifier closure.
    /// - Returns: `Self`
    public func `do`(_ action: @escaping (inout Root) -> Void) -> DoChain<Self> {
        DoChain(base: self, action: action)
    }
}
