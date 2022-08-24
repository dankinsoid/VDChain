import Foundation

/**
Wrapper that provides `method chaining` syntax for any type.

 Usage example:
```
let modifier = UILabel.self~.text("Some Text").textColor(.blue)

modifier.apply(
```
 */
@dynamicMemberLookup
public struct TypeChain<Root>: ConsistentChaining {
    
    public init() {}
    
    public func apply(on root: inout Root) {
    }
    
    public func getAllValues(for root: Root) -> Void {
        ()
    }
    
    public func applyAllValues(_ values: Void, for root: inout Root) {
    }
}

public postfix func ~<T>(_ lhs: T.Type) -> TypeChain<T> {
    TypeChain()
}

extension NSObjectProtocol {
    
    public static var chain: TypeChain<Self> {
        TypeChain()
    }
}
