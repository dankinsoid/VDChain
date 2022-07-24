//
// Created by Данил Войдилов on 20.05.2022.
// Copyright (c) 2022 tabby.ai. All rights reserved.
//

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
