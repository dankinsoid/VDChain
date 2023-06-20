import Foundation
@testable import VDChain
import XCTest

final class VDChainTests: XCTestCase {
    
    func testEmptyChaining() {
        let object = Object().chain
            .int(1)
            .string("1")
            .nested.double(1.0)
            .apply()

        XCTAssertEqual(object.int, 1)
        XCTAssertEqual(object.string, "1")
        XCTAssertEqual(object.nested.double, 1.0)
    }
    
    func testTypeChaining() {
        let modifier = Object.chain
            .int(1)
            .string("1")
            .nested.double(1.0)
        
        var object = Object()
        modifier.apply(on: &object)
        
        XCTAssertEqual(object.int, 1)
        XCTAssertEqual(object.string, "1")
        XCTAssertEqual(object.nested.double, 1.0)
    }
    
    func testMergeChaining() {
        let modifier = Object.chain
            .int(1)
            .nested.double(1.0)
        
        let object = Object().chain
            .string("1")
            .modifier(modifier)
            .apply()
        
        XCTAssertEqual(object.int, 1)
        XCTAssertEqual(object.string, "1")
        XCTAssertEqual(object.nested.double, 1.0)
    }
    
    func testCustomChaining() {
        let chaining = TestChaining<Object>().wrap()
            .int(1)
            .string("1")
            .nested.double(1.0)
            .base
        
        XCTAssertEqual(chaining.properties[\.int] as? Int, 1)
        XCTAssertEqual(chaining.properties[\.string] as? String, "1")
        XCTAssertEqual(chaining.properties[\.nested.double] as? Double, 1.0)
    }
}

private final class Object: Chainable {
    
    var int = 0
    var string = ""
    var nested = Nested()
    
    struct Nested {
        var double = 0.0
    }
}

private struct TestChaining<Root>: Chaining {
    
    var properties: [PartialKeyPath<Root>: Any] = [:]
    
    mutating func set<T>(_ keyPath: WritableKeyPath<Root, T>, _ value: T, values: ChainValues<Root>) -> (inout Root) -> Void {
        properties[keyPath] = value
        return { _ in
        }
    }
}
