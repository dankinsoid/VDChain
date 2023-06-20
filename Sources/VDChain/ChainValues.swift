import Foundation

public struct ChainValues<Root> {
    
    private var values: [PartialKeyPath<ChainValues>: (Any, (Any, Any) -> Any)] = [:]
    
    public init() {
    }
    
    public func get<T>(_ key: WritableKeyPath<ChainValues, T>) -> T? {
        values[key]?.0 as? T
    }
    
    public mutating func set<T>(
        _ key: WritableKeyPath<ChainValues, T>,
        _ newValue: T?,
        uniquingWith: @escaping (T, T) -> T = { _, new in new }
    ) {
        values[key] = newValue.map { newValue in
            (
                newValue,
                {
                    guard let old = $0 as? T, let new = $1 as? T else {
                        return newValue
                    }
                    return uniquingWith(old, new)
                }
            )
        }
    }
    
    public mutating func merge(_ other: ChainValues) {
        values.merge(other.values) { old, new in
            (
                new.1(old.0, new.0),
                new.1
            )
        }
    }
    
    public func merging(_ other: ChainValues) -> ChainValues {
        var result = self
        result.merge(other)
        return result
    }
}

extension ChainValues {
    
    public var apply: (inout Root) -> Void {
        get { get(\.apply) ?? { _ in } }
        set {
            set(\.apply, newValue) { old, new in
                {
                    old(&$0)
                    new(&$0)
                }
            }
        }
    }
}
