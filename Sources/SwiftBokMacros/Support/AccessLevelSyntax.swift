import SwiftSyntax

public enum AccessLevelModifier: String, Comparable, CaseIterable {
    case `private`
    case `fileprivate`
    case `internal`
    case `public`
    case `open`

    public var keyword: Keyword {
        switch self {
        case .private: .private
        case .fileprivate: .fileprivate
        case .internal: .internal
        case .public: .public
        case .open: .open
        }
    }

    public static func <(lhs: AccessLevelModifier, rhs: AccessLevelModifier) -> Bool {
        let lhs = Self.allCases.firstIndex(of: lhs)!
        let rhs = Self.allCases.firstIndex(of: rhs)!
        return lhs < rhs
    }
}

public protocol AccessLevelSyntax {
    var modifiers: DeclModifierListSyntax { get set }
}

extension AccessLevelSyntax {
    public var accessLevel: AccessLevelModifier {
        get { modifiers.lazy.compactMap({ AccessLevelModifier(rawValue: $0.name.text) }).first ?? .internal }
        set {
            let new = DeclModifierSyntax(name: .keyword(newValue.keyword))
            var newModifiers = modifiers.filter { AccessLevelModifier(rawValue: $0.name.text) == nil }
            newModifiers.append(new)
            modifiers = newModifiers
        }
    }
}

extension StructDeclSyntax: AccessLevelSyntax { }
extension ClassDeclSyntax: AccessLevelSyntax { }
extension EnumDeclSyntax: AccessLevelSyntax { }
extension ActorDeclSyntax: AccessLevelSyntax { }

extension FunctionDeclSyntax: AccessLevelSyntax { }
extension VariableDeclSyntax: AccessLevelSyntax { }

extension DeclGroupSyntax {
    public var declAccessLevel: AccessLevelModifier {
        get { (self as? AccessLevelSyntax)?.accessLevel ?? .internal }
    }
}
