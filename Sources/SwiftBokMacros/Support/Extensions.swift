import SwiftSyntax

extension DeclGroupSyntax {
    public var properties: [VariableDeclSyntax] {
        memberBlock.members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
    }
    public var functions: [FunctionDeclSyntax] {
        memberBlock.members.compactMap { $0.decl.as(FunctionDeclSyntax.self) }
    }
    public var storedProperties: [VariableDeclSyntax] {
        properties.filter(\.isStored)
    }
    public var initializers: [InitializerDeclSyntax] {
        memberBlock.members.compactMap { $0.decl.as(InitializerDeclSyntax.self) }
    }
    public var associatedTypes: [AssociatedTypeDeclSyntax] {
        memberBlock.members.compactMap { $0.decl.as(AssociatedTypeDeclSyntax.self) }
    }
}

extension FunctionDeclSyntax {
    public var `return`: ReturnClauseSyntax? {
        signature.returnClause
    }
    public var returnOrVoid: ReturnClauseSyntax {
        signature.returnClause ?? ReturnClauseSyntax(type: TypeSyntax("Void"))
    }
    public var parameters: FunctionParameterListSyntax {
        signature.parameterClause.parameters
    }
    public var isThrowing: Bool {
        signature.effectSpecifiers?.throwsSpecifier != nil
    }
    public var isAsync: Bool {
        signature.effectSpecifiers?.asyncSpecifier != nil
    }
}

extension FunctionParameterListSyntax {
    public var types: [TypeSyntax] {
        map(\.type)
    }
    public var typesWithoutAttribues: [TypeSyntax] {
        types.map { type in
            if let type = type.as(AttributedTypeSyntax.self) {
                type.with(\.attributes, []).baseType
            } else {
                type
            }
        }
    }
}

public protocol IdentifiableDeclSyntax {
    var identifier: TokenSyntax { get }
}
extension StructDeclSyntax: IdentifiableDeclSyntax {}
extension ClassDeclSyntax: IdentifiableDeclSyntax {}
extension EnumDeclSyntax: IdentifiableDeclSyntax {}
extension ActorDeclSyntax: IdentifiableDeclSyntax {}
extension VariableDeclSyntax: IdentifiableDeclSyntax {}

extension DeclGroupSyntax {
    public var identifier: TokenSyntax? {
        (self as? IdentifiableDeclSyntax)?.identifier
    }
}
