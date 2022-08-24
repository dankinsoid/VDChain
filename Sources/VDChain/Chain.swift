import Foundation

/**
 Wrapper that provides `method chaining` syntax for any value.

 Usage example:
```
let label = UILabel()~
                .text("Some Text")
                .textColor(.blue)
                .apply()
```
 */
@dynamicMemberLookup
public struct Chain<Value>: ValueChaining {
    
    /// value to modify
    public var value: Value
    public var applier: (inout Value) -> Void = { _ in }

    /// Initialization
    ///
    /// - Parameter value: the value to modify
    public init(_ value: Value) {
        self.value = value
    }
}

postfix operator ~

///Creates a `Chain` instance
public postfix func ~<Value>(_ lhs: Value) -> Chain<Value> {
    Chain(lhs)
}

extension NSObjectProtocol {
    
    public var chain: Chain<Self> {
        Chain(self)
    }
}
