import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct SwiftBokPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        InitMacro.self,
        MembersMacro.self,
        SetterMacro.self
    ]
}
