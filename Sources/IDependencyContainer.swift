//
//  IDependencyContainer.swift
//  
//
//  Created by Черепянко Валентин Александрович on 05/04/2020.
//

public enum DependencyType {
    // every resolve == new object
    case unique
    // weak link, if object is dead - rebuild
    case weakSingle
    // strong link, one object for container
    case single
}

public protocol IDependencyContainer {
    func register<T>(_ type: DependencyType, _ builder: @escaping (IDependencyContainer) -> T)
    func resolve<T>() -> T
}

// MARK: - abstraction convenience methods
public extension IDependencyContainer {

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
