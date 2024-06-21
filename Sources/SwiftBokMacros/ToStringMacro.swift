import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

private enum ToStringError: String, Error, DiagnosticMessage {
    var diagnosticID: MessageID { .init(domain: "SetterMacro", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
    var message: String {
        switch self {
        case .notAGroup: "@ToString can only be applied to struct/class"
        case .invalidArgument: "@ToString has some argument"
        }
    }
    
    case notAGroup
    case invalidArgument
}

public struct ToStringMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        var groupDecl: DeclGroupSyntax
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            groupDecl = classDecl
        } else if let structDecl = declaration.as(StructDeclSyntax.self) {
            groupDecl = structDecl
        } else {
            throw ToStringError.notAGroup
        }
        
        let member = groupDecl.storedProperties
        return []
    }
}
