import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

private enum SetterError: String, Error, DiagnosticMessage {
    var diagnosticID: MessageID { .init(domain: "SetterMacro", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
    var message: String {
        switch self {
        case .notAGroup: "@Setter can only be applied to struct/class"
        case .invalidArgument: "@Setter has some argument"
        }
    }
    
    case notAGroup
    case invalidArgument
}

public struct SetterMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard case .argumentList(let arguments) = node.arguments,
              let boolExpr = arguments.first?.expression.as(BooleanLiteralExprSyntax.self) ?? .some(false),
              let isPublic = Bool("\(boolExpr)") else {
            throw SetterError.invalidArgument
        }
        var groupDecl: DeclGroupSyntax
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            groupDecl = classDecl
        } else if let structDecl = declaration.as(StructDeclSyntax.self) {
            groupDecl = structDecl
        } else {
            throw SetterError.notAGroup
        }
        
        return groupDecl.storedProperties
            .filter { !$0.isStatic && ($0.bindingSpecifier.text == "var") }
            .map {
                    """
    \(raw: isPublic ? "public " : "")func \($0.identifier)(_ \($0.identifier)\($0.type!)) -> \(raw: groupDecl.identifier ?? "") {
        self.\($0.identifier) = \($0.identifier)
        return self
    }
    """
            }
    }
}
