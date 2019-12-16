import XCTest
@testable import InfernoKit

final class InfernoTests: XCTestCase {
    func testExample() {
        let names = try! Parser.parse(url: URL(fileURLWithPath: "/Users/ian/code/ileitch/inferno/Sources/InfernoKit/Parser.swift"))
        print("Symbol names: \(names)")

        let s = try! IndexStore(storeUrl: URL(fileURLWithPath: "/Users/ian/code/ileitch/inferno/.build/x86_64-apple-macosx/debug/index/store"))

        names.forEach {
            print("Symbols for '\($0)': \(s.get(name: $0))")
        }

        print("All symbol names: \(s.allSymbolNames())")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
