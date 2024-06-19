import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

private enum SetterError: String, Error, DiagnosticMessage {
    var diagnosticID: MessageID { .init(domain: "InternalInitMacro", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
    var message: String {
        switch self {
        case .notAClass: return "@InternalInit can only be applied to structs"
        }
    }
    
    case notAClass
}

public struct SetterMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            throw SetterError.notAClass
        }
        return classDecl.properties
            .map {
                    """
    func \($0.identifier)(_ \($0.identifier)\($0.type!)) -> \(classDecl.name) {
        self.\($0.identifier) = \($0.identifier)
        return self
    }
    """
            }
    }
}

/**
 var a: Int
 
 func a(a: Int) {
 self.a = a
 }
 */

class A {
    var a: Int = 10
    func a(a: Int) {
        self.a = a
    }
}
