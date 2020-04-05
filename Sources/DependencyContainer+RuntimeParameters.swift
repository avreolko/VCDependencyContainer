//
//  DependencyContainer+RuntimeParameters.swift
//  
//
//  Created by Cherepyanko Valentin on 05/04/2020.
//

// MARK: - runtime parameters
public extension IDependencyContainer {
    func resolve<P, T>(with parameter: P) -> T {
        self.register { parameter }
        return self.resolve()
    }

    func resolve<P1, P2, T>(with firstParameter: P1, and secondParameter: P2) -> T {
        self.register { firstParameter }
        self.register { secondParameter }
        return self.resolve()
    }

    func resolve<P1, P2, P3, T>(with params: (P1, P2, P3)) -> T {
        self.register { params.0 }
        self.register { params.1 }
        self.register { params.2 }
        return self.resolve()
    }

    func resolve<P1, P2, P3, P4, T>(with params: (P1, P2, P3, P4)) -> T {
        self.register { params.0 }
        self.register { params.1 }
        self.register { params.2 }
        self.register { params.3 }
        return self.resolve()
    }

    func resolve<P1, P2, P3, P4, P5, T>(with params: (P1, P2, P3, P4, P5)) -> T {
        self.register { params.0 }
        self.register { params.1 }
        self.register { params.2 }
        self.register { params.3 }
        self.register { params.4 }
        return self.resolve()
    }
}


