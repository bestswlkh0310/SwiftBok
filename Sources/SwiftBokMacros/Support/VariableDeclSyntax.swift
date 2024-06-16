import SwiftSyntax

extension VariableDeclSyntax {
    func accessorsMatching(_ predicate: (TokenKind) -> Bool) -> [AccessorDeclSyntax] {
        bindings
            .compactMap { patternBinding in
                switch patternBinding.accessorBlock?.accessors {
                case let .accessors(accessors):
                    accessors
                default:
                    nil
                }
            }
            .flatMap { $0 }
            .compactMap { predicate($0.accessorSpecifier.tokenKind) ? $0 : nil }
    }
    
    public var isComputed: Bool {
        if accessorsMatching({ $0 == .keyword(.get) }).count > 0 {
            true
        } else {
            bindings.contains { binding in
                if case .getter = binding.accessorBlock?.accessors {
                    true
                } else {
                    false
                }
            }
        }
    }
    
    public var isStored: Bool {
        !isComputed
    }
    
    public var isStatic: Bool {
        modifiers.lazy.contains(where: { $0.name.tokenKind == .keyword(.static) }) == true
    }
    public var identifier: TokenSyntax {
        bindings.lazy.compactMap({ $0.pattern.as(IdentifierPatternSyntax.self) }).first!.identifier
    }
    
    public var type: TypeAnnotationSyntax? {
        bindings.lazy.compactMap(\.typeAnnotation).first
    }
    
    public var initializerValue: ExprSyntax? {
        bindings.lazy.compactMap(\.initializer).first?.value
    }
    
    public var effectSpecifiers: [AccessorEffectSpecifiersSyntax] {
        bindings
            .compactMap { $0.accessorBlock }
            .map(\.accessors)
            .flatMap { accessor -> [AccessorEffectSpecifiersSyntax] in
                switch accessor {
                case .getter:
                    []
                case .accessors(let list):
                    list.compactMap(\.effectSpecifiers)
                }
            }
    }
    public var isThrowing: Bool {
        effectSpecifiers.contains { effect in effect.throwsSpecifier != nil }
    }
    public var isAsync: Bool {
        effectSpecifiers.contains { effect in effect.asyncSpecifier != nil }
    }
}
