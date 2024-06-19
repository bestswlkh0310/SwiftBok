import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct SwiftBokPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        PublicInitMacro.self,
        InternalInitMacro.self,
        PublicMembersMacro.self,
        InternalMembersMacro.self,
        SetterMacro.self
    ]
}
