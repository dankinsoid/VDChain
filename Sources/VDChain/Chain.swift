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
public struct Chain<Root>: ValueChaining, ConsistentChaining {
    
    /// value to modify
    public var root: Root

    /// Initialization
    ///
    /// - Parameter value: the value to modify
    public init(_ root: Root) {
        self.root = root
    }
    
    public func apply(on root: inout Root) {
    }
    
    public func getAllValues(for root: Root) -> Void {
        ()
    }
    
    public func applyAllValues(_ values: Void, for root: inout Root) {
    }
}

postfix operator ~

///Creates a `Chain` instance
public postfix func ~<Root>(_ lhs: Root) -> Chain<Root> {
    Chain(lhs)
}

extension NSObjectProtocol {
    
    public var chain: Chain<Self> {
        Chain(self)
    }
}
