import Foundation

public struct ChainValues<Root> {
    
    private var values: [PartialKeyPath<ChainValues>: Any] = [:]
    
    public init() {
    }
    
    public subscript<T>(_ key: WritableKeyPath<ChainValues, T>) -> T? {
        get {
            values[key] as? T
        }
        set {
            values[key] = newValue
        }
    }
    
    public mutating func merge(_ other: ChainValues) {
        values.merge(other.values) { _, new in
            new
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
        get { self[\.apply] ?? { _ in } }
        set { self[\.apply] = newValue }
    }
}
