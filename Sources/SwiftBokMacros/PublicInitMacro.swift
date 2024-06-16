import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

private enum PublicInitError: String, Error, DiagnosticMessage {
    var diagnosticID: MessageID { .init(domain: "PublicInitMacro", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
    var message: String {
        switch self {
        case .notAStruct: return "@PublicInit can only be applied to structs"
        case .notPublic: return "@PublicInit can only be applied to public structs"
        }
    }
    
    case notAStruct
    case notPublic
}

private struct InferenceDiagnostic: DiagnosticMessage {
    let diagnosticID = MessageID(domain: "PublicInitMacro", id: "inference")
    let severity: DiagnosticSeverity = .error
    let message: String = "@PublicInit requires stored properties provide explicit type annotations"
}

public struct PublicInitMacro: MemberMacro {
    
    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else { throw PublicInitError.notAStruct }
        guard structDecl.accessLevel == .public else { throw PublicInitError.notPublic }
        
        var included: [VariableDeclSyntax] = []
        
        for property in structDecl.storedProperties {
            guard !property.isStatic else { continue }
            
            if property.type != nil {
                included.append(property)
            } else {
                context.diagnose(.init(node: property._syntaxNode, message: InferenceDiagnostic()))
            }
        }
        
        let initializer = try InitializerDeclSyntax("""
public init(
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
