import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

private enum MembersError: String, Error, DiagnosticMessage {
    var diagnosticID: MessageID { .init(domain: "PublicInitMacro", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
    var message: String {
        switch self {
        case .notAGroup: "@Members can only be applied to class/struct"
        case .notPublic: "@Members can only be applied to public"
        case .notInternal: "@Members can only be applied to internal"
        case .invalidArgument: "@Members has some argument"
        }
    }
    
    case notAGroup
    case notPublic
    case notInternal
    case invalidArgument
}

private struct InferenceDiagnostic: DiagnosticMessage {
    let diagnosticID = MessageID(domain: "MembersMacro", id: "inference")
    let severity: DiagnosticSeverity = .error
    let message: String = "@PublicMembers requires stored properties provide explicit type annotations"
}

public struct MembersMacro: MemberAttributeMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard case .argumentList(let argument) = node.arguments,
              let boolExpr = argument.first?.expression.as(BooleanLiteralExprSyntax.self) ?? .some(true),
              let isPublic = Bool("\(boolExpr)") else {
            throw MembersError.invalidArgument
        }
        
        var group: DeclGroupSyntax
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            group = classDecl
            if isPublic {
                guard classDecl.accessLevel == .public else { throw MembersError.notPublic }
            }
        } else if let structDecl = declaration.as(StructDeclSyntax.self) {
            group = structDecl
            if isPublic {
                guard structDecl.accessLevel == .public else { throw MembersError.notPublic }
            }
        } else {
            throw MembersError.notAGroup
        }
        
        let memberAccessLevel: AccessLevelModifier = isPublic ? .public : .internal
        
        for property in group.properties {
            if property.accessLevel == memberAccessLevel {
                continue
            }
            throw isPublic ? MembersError.notPublic : MembersError.notInternal
        }
        return []
    }
}
