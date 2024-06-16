import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

private enum InternalMembersError: String, Error, DiagnosticMessage {
    var diagnosticID: MessageID { .init(domain: "InternalInitMacro", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
    var message: String {
        switch self {
        case .notAGroup: return "@InternalMembers can only be applied to structs"
        case .notInternal: return "@InternalMembers can only be applied to internal"
        }
    }
    
    case notAGroup
    case notInternal
}

private struct InferenceDiagnostic: DiagnosticMessage {
    let diagnosticID = MessageID(domain: "InternalMembersMacro", id: "inference")
    let severity: DiagnosticSeverity = .error
    let message: String = "@InternalMembers requires stored properties provide explicit type annotations"
}

public struct InternalMembersMacro: MemberAttributeMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        var group: DeclGroupSyntax
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            group = classDecl
        } else if let structDecl = declaration.as(StructDeclSyntax.self) {
            group = structDecl
        } else {
            throw InternalMembersError.notAGroup
        }
        
        for property in group.properties {
            if property.accessLevel != .internal {
                throw InternalMembersError.notInternal
            }
        }
        return []
    }
}
