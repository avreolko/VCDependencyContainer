//
//  DependencyContainer+RuntimeParameters.swift
//  VCDependencyContainer
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


