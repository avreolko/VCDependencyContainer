# VCDependencyContainer

Simple DI container

## Installation
Install with SPM 📦

## Features
- Interface segregation. You can register one builder for multiple interfaces and then retrieve object by each on of these interfaces individually:
```swift
    protocol Foo { }
    protocol Bar { }
    class A: Foo & Bar { }

    let container = DependencyContainer()
    container.register { A() as Foo & Bar }

    let validObject = container.resolve() as Foo
    let anotherValidObject = container.resolve() as Bar
```

- Lifecycle management. Manage your dependency lifecycle per container:
```swift
    class Foo { }
    class Bar { }
    
    let container = DependencyContainer()
    
    container.register(.single) { Foo() }
    let someFoo = container.resolve() as Foo
    let anotherFoo = container.resolve() as Foo
    print(someFoo === anotherFoo) // true
    
    container.register(.unique) { Bar() }
    let someBar = container.resolve() as Bar
    let anotherBar = container.resolve() as Bar
    print(someBar === anotherBar) // false
```

- Optional types support:
```swift
    class Foo { }

    let container = DependencyContainer()
    container.register { Foo() }
    
    func bar(foo: Foo?) { ... }
    
    bar(container.resolve()) // valid
```

## To do
- Thread safety

## License
This project is released under the [MIT license](https://en.wikipedia.org/wiki/MIT_License).
