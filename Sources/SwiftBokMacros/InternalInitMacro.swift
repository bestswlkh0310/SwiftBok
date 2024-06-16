import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

private enum InternalInitError: String, Error, DiagnosticMessage {
    var diagnosticID: MessageID { .init(domain: "InternalInitMacro", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
    var message: String {
        switch self {
        case .notAStruct: return "@InternalInit can only be applied to structs"
        }
    }
    
    case notAStruct
}

private struct InferenceDiagnostic: DiagnosticMessage {
    let diagnosticID = MessageID(domain: "InternalInitMacro", id: "inference")
    let severity: DiagnosticSeverity = .error
    let message: String = "@InternalInit requires stored properties provide explicit type annotations"
}

public struct InternalInitMacro: MemberMacro {
    
    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else { throw InternalInitError.notAStruct }
        
        var included: [VariableDeclSyntax] = []
        
        for property in structDecl.storedProperties {
            guard !property.isStatic else { continue }
            guard property.bindingSpecifier.text == "var" || property.initializerValue == nil else { continue }
            
            if property.type != nil {
                included.append(property)
            } else {
                context.diagnose(.init(node: property._syntaxNode, message: InferenceDiagnostic()))
            }
        }
        
        let initializer = try InitializerDeclSyntax("""
init(
    \(raw: included.map { "\($0.bindings)" }.joined(separator: ",\n"))
)
""") {
            for include in included {
                ExprSyntax("self.\(include.identifier) = \(include.identifier)")
            }
        }
        return [DeclSyntax(initializer)]
    }
}
