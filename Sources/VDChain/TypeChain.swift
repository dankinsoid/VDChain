//
// Created by Данил Войдилов on 20.05.2022.
// Copyright (c) 2022 tabby.ai. All rights reserved.
//

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
public struct TypeChain<Value>: Chaining {
    public var applier: (inout Value) -> Void = { _ in }

    public init() {}
}

public postfix func ~<T>(_ lhs: T.Type) -> TypeChain<T> {
    TypeChain()
}
