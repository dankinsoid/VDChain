import Foundation

/// A type that provides chaining syntax for values.
public protocol ValueChaining: Chaining {
    
    var value: Value { get }
}

extension ValueChaining {

    ///Apply the chaining
    @discardableResult
    public func apply() -> Value {
        var result = value
        applier(&result)
        return result
    }

    public func modifier(_ chain: TypeChain<Value>) -> Self {
        self.do(chain.applier)
    }
}

///Creates a `Chain` instance
public postfix func ~<C: ValueChaining>(_ lhs: C) -> C.Value {
    lhs.apply()
}
