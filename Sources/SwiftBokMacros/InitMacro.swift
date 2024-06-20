import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

private enum InitError: String, Error, DiagnosticMessage {
    var diagnosticID: MessageID { .init(domain: "PublicInitMacro", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
    var message: String {
        switch self {
        case .notAStruct: "@Init can only be applied to struct"
        case .notPublic: "@Init can only be applied to public struct"
        case .invalidArgument: "@Init has some argument"
        }
    }
    
    case notAStruct
    case notPublic
    case invalidArgument
}

private struct InferenceDiagnostic: DiagnosticMessage {
    let diagnosticID = MessageID(domain: "PublicInitMacro", id: "inference")
    let severity: DiagnosticSeverity = .error
    let message: String = "@Init requires stored properties provide explicit type annotations"
}

public struct InitMacro: MemberMacro {
    
    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard case .argumentList(let arguments) = node.arguments,
              let boolExpr = arguments.first?.expression.as(BooleanLiteralExprSyntax.self) ?? .some(true),
              let isPublic = Bool("\(boolExpr)") else {
            throw InitError.invalidArgument
        }
        
        guard let structDecl = declaration.as(StructDeclSyntax.self) else { throw InitError.notAStruct }
        if isPublic {
            guard structDecl.accessLevel == .public else { throw InitError.notPublic }
        }
        
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
\(raw: isPublic ? "public " : "")init(
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
