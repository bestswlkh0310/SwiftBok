import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SwiftBokMacros

private let testMacros: [String: Macro.Type] = [
    "InternalInit": InternalInitMacro.self
]

final class InternalInitMacroTests: XCTestCase {
    func testInternalInit_HappyPath() {
        assertMacroExpansion(
            """
            @InternalInit
            struct Foo {
                var a: String
                private var b: Int = 42
                var c = true
                var b2: Int {
                    return b + 1
                }
            }
            """,
            expandedSource: """
            
            struct Foo {
                var a: String
                private var b: Int = 42
                var c = true
                var b2: Int {
                    return b + 1
                }

                init(
                    a: String,
                    b: Int = 42
                ) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            diagnostics: [
                .init(message: "@InternalInit requires stored properties provide explicit type annotations", line: 5, column: 5)
            ],
            macros: testMacros
        )
    }
    func testInternalInit_HappyPath_Empty() {
        assertMacroExpansion(
            """
            @InternalInit
            struct Foo {
            }
            """,
            expandedSource: """

            struct Foo {
            
                init(

                ) {
                }
            }
            """,
            macros: testMacros
        )
    }
    func testInternalInit_HappyPath_IgnoreStaticProperties() {
        assertMacroExpansion(
            """
            @InternalInit
            struct Foo {
                static var a: Int = 0
                let b: Double
            }
            """,
            expandedSource: """

            struct Foo {
                static var a: Int = 0
                let b: Double
            
                init(
                    b: Double
                ) {
                    self.b = b
                }
            }
            """,
            macros: testMacros
        )
    }
    func testInternalInit_Failure_AccessPrivate() {
        assertMacroExpansion(
            """
            @InternalInit
            private struct Foo {
                var a: String
            }
            """,
            expandedSource: """

            private struct Foo {
                var a: String
            
                init(
                    a: String
                ) {
                    self.a = a
                }
            }
            """,
            macros: testMacros
        )
    }
    func testInternalInit_Failure_AccessImplicitInternal() {
        assertMacroExpansion(
            """
            @InternalInit
            struct Foo {
                var a: String
            }
            """,
            expandedSource: """

            struct Foo {
                var a: String
            
                init(
                    a: String
                ) {
                    self.a = a
                }
            }
            """,
            macros: testMacros
        )
    }
    func testInternalInit_Failure_AccessExplicitInternal() {
        assertMacroExpansion(
            """
            @InternalInit
            internal struct Foo {
                var a: String
            }
            """,
            expandedSource: """

            internal struct Foo {
                var a: String
            
                init(
                    a: String
                ) {
                    self.a = a
                }
            }
            """,
            macros: testMacros
        )
    }
    func testInternalInit_Failure_Class() {
        assertMacroExpansion(
            """
            @InternalInit
            class Foo {
                var a: String
            }
            """,
            expandedSource: """

            class Foo {
                var a: String
            }
            """,
            diagnostics: [
                .init(message: "@InternalInit can only be applied to structs", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    func testInternalInit_Failure_Enum() {
        assertMacroExpansion(
            """
            @InternalInit
            enum Foo {
                case a
            }
            """,
            expandedSource: """

            enum Foo {
                case a
            }
            """,
            diagnostics: [
                .init(message: "@InternalInit can only be applied to structs", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    func testInternalInit_Failure_Actor() {
        assertMacroExpansion(
            """
            @InternalInit
            actor Foo {
                var a: String
            }
            """,
            expandedSource: """

            actor Foo {
                var a: String
            }
            """,
            diagnostics: [
                .init(message: "@InternalInit can only be applied to structs", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
