//
//  DependencyContainer.swift
//
//
//  Created by Cherepyanko Valentin on 05/04/2020.
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

import VCWeakContainer
import Foundation

// MARK: - implementation
public final class DependencyContainer: IDependencyContainer {

    internal typealias Keys = Set<String>
    internal typealias Builder = (IDependencyContainer) -> Any

    struct Definition {
        let type: DependencyType
        let keys: Keys
        let builder: Builder
    }

    private var definitions: [Definition] = []

    private var sharedItems: [Any] = []
    private var singleObjects: [Weak<AnyObject>] = []

    private let typeMapper = TypeMapper()

    public init() { }

    public func register<T>(_ type: DependencyType = .unique,
                            _ builder: @escaping (IDependencyContainer) -> T) {
        let types = self.typeMapper.registrationKeys(for: T.self)
        self.definitions.append(Definition(type: type, keys: types, builder: builder))
    }

    public func resolve<T>() -> T {

        let keys = self.resolvingKeys(for: T.self)
        let definition = self.definition(for: keys)

        switch definition.type {
        case .unique:
            return self.resolveUnique(with: definition.builder)
        case .weakSingle:
            return self.resolveWeakSingle(with: definition.builder)
        case .single:
            return self.resolveSingle(with: definition.builder)
        }
    }
}

// MARK: - implementation convenience methods
public extension DependencyContainer {

    func register<T>(_ builder: @escaping (IDependencyContainer) -> T) {
        self.register(.unique, builder)
    }

    func register<T>(_ builder: @escaping () -> T) {
        self.register(.unique, { _ in builder() })
    }

    func register<T>(_ type: DependencyType, _ builder: @escaping () -> T) {
        self.register(type, { _ in builder() })
    }
}

// MARK: - auxiliary
private extension DependencyContainer {

    func resolveUnique<T>(with builder: Builder) -> T {
        return builder(self) as! T
    }

    func resolveWeakSingle<T>(with builder: Builder) -> T {
        if let box = self.singleObjects.first(where: { ($0.object is T) && ($0.object != nil) }) {
            return box.object as! T
        } else {
            let object = builder(self)
            self.singleObjects.append(Weak(object as AnyObject))
            return object as! T
        }
    }

    func resolveSingle<T>(with builder: Builder) -> T {
        if let object = self.sharedItems.first(where: { $0 is T }) {
            return object as! T
        } else {
            let object = builder(self)
            self.sharedItems.append(object)
            return object as! T
        }
    }
}

// MARK: - utils
private extension DependencyContainer {

    func resolvingKeys(for type: Any.Type) -> Keys {

        let typeName = "\(type)"

        if typeName.contains("Optional<") {
            return Set([typeName])
        }

        return Set(
            "\(type)"
            .split(separator: "&")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        )
    }

    func definition(for keys: Keys) -> Definition {

        guard let definition = (self.definitions.first { definition in
            keys.isSubset(of: definition.keys)
        }) else { fatalError("⚠️ No definition found for: \(keys)") }

        return definition
    }
}
