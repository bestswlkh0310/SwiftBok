import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

private enum SetterError: String, Error, DiagnosticMessage {
    var diagnosticID: MessageID { .init(domain: "InternalInitMacro", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
    var message: String {
        switch self {
        case .notAClass: "@Setter can only be applied to class"
        case .invalidArgument: "@Setter has some argument"
        }
    }
    
    case notAClass
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
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            throw SetterError.notAClass
        }
        
        return classDecl.storedProperties
            .filter { !$0.isStatic && ($0.bindingSpecifier.text == "var") }
            .map {
                    """
    \(raw: isPublic ? "public " : "")func \($0.identifier)(_ \($0.identifier)\($0.type!)) -> \(classDecl.name) {
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
