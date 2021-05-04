//
//  DependencyContainerTests.swift
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

protocol Foo { }
protocol Bar { }
protocol Cin { }

final class DependencyContainerTests: XCTestCase {

    private var container: IDependencyContainer!

    override func setUp() {
        super.setUp()
        self.container = DependencyContainer()
    }

    func test_one_dependency() {
        class A: Foo {}
        self.container.register { A() as Foo }
        _ = self.container.resolve() as Foo
    }

    func test_complex_tree() {
        struct A { }
        struct B { let a: A }
        struct C { let a: A; let b: B }

        self.container.register { A() }
        self.container.register { B(a: $0.resolve()) }
        self.container.register { C(a: $0.resolve(), b: $0.resolve()) }

        _ = self.container.resolve() as C
    }

    // MARK: - optionality
    func test_optional_registration() {
        class A: Foo { }
        self.container.register { A() as Foo? }
        _ = self.container.resolve() as Foo?
    }

    func test_optional_resolving() {
        class A: Foo { }
        self.container.register { A() as Foo }
        _ = self.container.resolve() as Foo?
    }

    func test_nil_registration() {
        self.container.register { nil as Foo? }
        XCTAssertNil(self.container.resolve() as Foo?)
    }

    func test_optional_resolving_reversed_multiple() {
        class A: Foo & Bar { }
        self.container.register { A() as (Foo & Bar)? }
        _ = self.container.resolve() as (Foo & Bar)?
    }

    func test_multiple_interfaces_and_one_optional_parameter() {
        class A: Foo & Bar {}
        self.container.register { A() as Foo & Bar }
        _ = self.container.resolve() as Foo?
    }

    // disabled because crash is expected behaviour in this case
    func disabled_test_optional_resolving_reversed() {
        class A: Foo { }
        self.container.register { A() as Foo? }
        _ = self.container.resolve() as Foo
    }

    // MARK: - multiple interfaces
    func test_multiple_inheritance() {
        class A: Foo, Bar { }
        self.container.register { A() as Foo & Bar }

        _ = self.container.resolve() as Foo
        _ = self.container.resolve() as Bar
        _ = self.container.resolve() as Foo & Bar
    }

    func test_more_multiple_inheritance() {
        class A: Foo, Bar, Cin { }
        self.container.register { A() as Foo & Bar & Cin }

        _ = self.container.resolve() as Foo
        _ = self.container.resolve() as Foo & Bar
        _ = self.container.resolve() as Foo & Bar & Cin
    }

    func test_different_dependencies_order() {
        class A: Foo, Bar, Cin { }
        self.container.register { A() as Foo & Bar & Cin }
        _ = self.container.resolve() as Foo & Bar & Cin
        _ = self.container.resolve() as Foo & Cin & Bar
        _ = self.container.resolve() as Bar & Cin & Foo
    }

    func test_unnecessary_interfaces() {
        class A: Foo, Bar { }
        self.container.register { A() as Foo & Bar }
        _ = container.resolve() as Foo & Foo & Bar & Bar
        _ = container.resolve() as Foo & Bar & Bar & Foo
    }

    // MARL: special types
    func test_arrays() {
        let array = [1, 2, 3]
        self.container.register { array }
        XCTAssertEqual(self.container.resolve() as [Int], array)
    }

    func test_generic_types() {
        struct Wrapper<Value> { let value: Value }
        self.container.register { Wrapper(value: 10) }
        _ = self.container.resolve() as Wrapper<Int>
    }

    // MARK: - scope testing
    func test_unique_resolving() {
        class A { }
        self.container.register { A() as AnyObject }
        let a1: AnyObject = self.container.resolve()
        let a2: AnyObject = self.container.resolve()
        XCTAssertFalse(a1 === a2)
    }

    func test_single_resolving_classes() {
        class A { }
        self.container.register(.single) { A() as AnyObject }
        let a1: AnyObject = self.container.resolve()
        let a2: AnyObject = self.container.resolve()
        XCTAssertTrue(a1 === a2)
    }

    func test_single_resolving_structs() {
        struct A { let uuid = UUID().uuidString }
        self.container.register(.single) { A() }
        let a1: A = self.container.resolve()
        let a2: A = self.container.resolve()
        XCTAssertTrue(a1.uuid == a2.uuid)
    }

    func test_weak_single() {
        class A { }
        self.container.register(.weakSingle) { A() as AnyObject }
        weak var a: AnyObject? = self.container.resolve()
        XCTAssertNil(a)
    }

    func test_weak_single_structs() {
        struct A { let uuid = UUID().uuidString }
        self.container.register(.weakSingle) { A() }
        let a1: A = self.container.resolve()
        let a2: A = self.container.resolve()
        XCTAssertFalse(a1.uuid == a2.uuid)
    }

    // MARK: - runtime parameters
    func test_one_parameter() {

        class A {
            var value: Int
            init(value: Int) { self.value = value }
        }

        self.container.register { A(value: $0.resolve()) }

        let a: A = self.container.resolve(with: 10)
        XCTAssertEqual(a.value, 10)
    }
}
