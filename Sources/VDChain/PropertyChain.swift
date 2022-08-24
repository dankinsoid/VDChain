import Foundation

/// Helper type for chaining
@dynamicMemberLookup
public struct PropertyChain<Base: Chaining, Value> {
    
    public let chaining: Base
    public let getter: KeyPath<Base.Value, Value>

    public init(_ value: Base, getter: KeyPath<Base.Value, Value>) {
        chaining = value
        self.getter = getter
    }

    public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> PropertyChain<Base, A> {
        PropertyChain<Base, A>(chaining, getter: getter.appending(path: keyPath))
    }

    public func callAsFunction(_ value: Value) -> Base {
        guard let kp = getter as? WritableKeyPath<Base.Value, Value> else { return chaining }
        var result = chaining
        result.applier = { [chaining] result in
            chaining.applier(&result)
            result[keyPath: kp] = value
        }
        return result
    }
}

extension PropertyChain {

    public subscript<T, A>(dynamicMember keyPath: KeyPath<T, A>) -> PropertyChain<Base, A?> where Value == T? {
        PropertyChain<Base, A?>(chaining, getter: getter.appending(path: \.[keyPath]))
    }

    public subscript<T, A>(dynamicMember keyPath: WritableKeyPath<T, A?>) -> PropertyChain<Base, A?> where Value == T? {
        PropertyChain<Base, A?>(chaining, getter: getter.appending(path: \.[writable: keyPath]))
    }
}

private extension Optional {

    subscript<B>(_ keyPath: KeyPath<Wrapped, B>) -> B? {
        self?[keyPath: keyPath]
    }

    subscript<B>(writable keyPath: WritableKeyPath<Wrapped, B?>) -> B? {
        get {
            self?[keyPath: keyPath]
        }
        set {
            if let value = newValue {
                self?[keyPath: keyPath] = value
            } else {
                self?[keyPath: keyPath] = .none
            }
        }
    }
}
