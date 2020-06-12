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
