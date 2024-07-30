import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SwiftBokMacros

private let testMacros: [String: Macro.Type] = [
    "Init": InitMacro.self
]

final class PublicInitMacroTests: XCTestCase {
    func testPublicInit_HappyPath() {
        assertMacroExpansion(
            """
            @Init()
            public struct Foo {
                var a: String
                private var b: Int = 42
                var c = true
                var b2: Int {
                    return b + 1
                }
            }
            """,
            expandedSource: """
            
            public struct Foo {
                var a: String
                private var b: Int = 42
                var c = true
                var b2: Int {
                    return b + 1
                }

                public init(
                    a: String,
                    b: Int = 42
                ) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            diagnostics: [
                .init(message: "@Init requires stored properties provide explicit type annotations", line: 5, column: 5)
            ],
            macros: testMacros
        )
    }
    func testPublicInit_HappyPath_Empty() {
        assertMacroExpansion(
            """
            @Init()
            public struct Foo {
            }
            """,
            expandedSource: """

            public struct Foo {
            
                public init(

                ) {
                }
            }
            """,
            macros: testMacros
        )
    }
    func testPublicInit_HappyPath_IgnoreStaticProperties() {
        assertMacroExpansion(
            """
            @Init()
            public struct Foo {
                static var a: Int = 0
                let b: Double
            }
            """,
            expandedSource: """

            public struct Foo {
                static var a: Int = 0
                let b: Double
            
                public init(
                    b: Double
                ) {
                    self.b = b
                }
            }
            """,
            macros: testMacros
        )
    }
    func testPublicInit_Failure_AccessPrivate() {
        assertMacroExpansion(
            """
            @Init()
            private struct Foo {
                var a: String
            }
            """,
            expandedSource: """

            private struct Foo {
                var a: String
            }
            """,
            diagnostics: [
                .init(message: "@Init can only be applied to public struct", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    func testPublicInit_Failure_AccessImplicitInternal() {
        assertMacroExpansion(
            """
            @Init()
            struct Foo {
                var a: String
            }
            """,
            expandedSource: """

            struct Foo {
                var a: String
            }
            """,
            diagnostics: [
                .init(message: "@Init can only be applied to public struct", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    func testPublicInit_Failure_AccessExplicitInternal() {
        assertMacroExpansion(
            """
            @Init()
            internal struct Foo {
                var a: String
            }
            """,
            expandedSource: """

            internal struct Foo {
                var a: String
            }
            """,
            diagnostics: [
                .init(message: "@Init can only be applied to public struct", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    func testPublicInit_Failure_Class() {
        assertMacroExpansion(
            """
            @Init()
            public class Foo {
                var a: String
            }
            """,
            expandedSource: """

            public class Foo {
                var a: String
            }
            """,
            diagnostics: [
                .init(message: "@Init can only be applied to struct", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    func testPublicInit_Failure_Enum() {
        assertMacroExpansion(
            """
            @Init()
            public enum Foo {
                case a
            }
            """,
            expandedSource: """

            public enum Foo {
                case a
            }
            """,
            diagnostics: [
                .init(message: "@Init can only be applied to struct", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    func testPublicInit_Failure_Actor() {
        assertMacroExpansion(
            """
            @Init()
            public actor Foo {
                var a: String
            }
            """,
            expandedSource: """

            public actor Foo {
                var a: String
            }
            """,
            diagnostics: [
                .init(message: "@Init can only be applied to struct", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
