//
//  TypeMapperTests.swift
//  VCDependencyContainerTests
//
//  Created by Valentin Cherepyanko on 24.06.2020.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest
@testable import VCDependencyContainer

final class TypeMapperTests: XCTestCase {

    private var typeMapper: TypeMapper!

    override func setUp() {
        super.setUp()
        self.typeMapper = TypeMapper()
    }

    func test_unary_type() {
        class A {}
        XCTAssertEqual(
            self.typeMapper.registrationKeys(for: A.self),
            Set(arrayLiteral: "A", "Optional<A>")
        )
    }

    func test_multiple_types() {
        XCTAssertEqual(
            self.typeMapper.registrationKeys(for: (Foo & Bar).self),
            Set(arrayLiteral: "Foo", "Optional<Foo>", "Bar", "Optional<Bar>", "Bar & Foo", "Optional<Bar & Foo>")
        )
    }

    func test_unary_optional_type() {
        XCTAssertEqual(
            self.typeMapper.registrationKeys(for: (Foo?).self),
            Set(arrayLiteral: "Optional<Foo>")
        )
    }

    func test_multiple_optional_types() {
        XCTAssertEqual(
            self.typeMapper.registrationKeys(for: (Foo & Bar)?.self),
            Set(arrayLiteral: "Optional<Bar & Foo>")
        )
    }

    func test_deterministic_order() {

        let order1 = (Foo & Bar & Cin).self
        let order2 = (Bar & Foo & Cin).self
        let order3 = (Foo & Cin & Bar).self

        XCTAssertTrue(self.typeMapper.registrationKeys(for: order1).contains("Bar & Cin & Foo"))
        XCTAssertTrue(self.typeMapper.registrationKeys(for: order2).contains("Bar & Cin & Foo"))
        XCTAssertTrue(self.typeMapper.registrationKeys(for: order3).contains("Bar & Cin & Foo"))

    }

    func test_multiple_equal_types() {
        XCTAssertEqual(
            self.typeMapper.registrationKeys(for: (Foo & Foo & Foo).self),
            Set(arrayLiteral: "Foo", "Optional<Foo>")
        )
    }

    func test_partial_multiple_equal_types() {
        XCTAssertEqual(
            self.typeMapper.registrationKeys(for: (Foo & Foo & Bar).self),
            Set(arrayLiteral: "Foo", "Optional<Foo>", "Bar", "Optional<Bar>", "Bar & Foo", "Optional<Bar & Foo>")
        )
    }
}
