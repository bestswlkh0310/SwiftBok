import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

private enum PublicMembersError: String, Error, DiagnosticMessage {
    var diagnosticID: MessageID { .init(domain: "PublicInitMacro", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
    var message: String {
        switch self {
        case .notAGroup: return "@PublicMembers can only be applied to structs"
        case .notPublic: return "@PublicMembers can only be applied to public structs"
        }
    }
    
    case notAGroup
    case notPublic
}

private struct InferenceDiagnostic: DiagnosticMessage {
    let diagnosticID = MessageID(domain: "PublicMembersMacro", id: "inference")
    let severity: DiagnosticSeverity = .error
    let message: String = "@PublicMembers requires stored properties provide explicit type annotations"
}

public struct PublicMembersMacro: MemberAttributeMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        var group: DeclGroupSyntax
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            group = classDecl
            guard classDecl.accessLevel == .public else { throw PublicMembersError.notPublic }
        } else if let structDecl = declaration.as(StructDeclSyntax.self) {
            group = structDecl
            guard structDecl.accessLevel == .public else { throw PublicMembersError.notPublic }
        } else {
            throw PublicMembersError.notAGroup
        }
        
        for property in group.properties {
            if property.accessLevel != .public {
                throw PublicMembersError.notPublic
            }
        }
        return []
    }
}
