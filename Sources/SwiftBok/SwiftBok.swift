@attached(member, names: named(init))
public macro PublicInit() = #externalMacro(module: "SwiftBokMacros", type: "PublicInitMacro")

@attached(member, names: named(init))
public macro InternalInit() = #externalMacro(module: "SwiftBokMacros", type: "InternalInitMacro")

@attached(memberAttribute)
public macro PublicMembers() = #externalMacro(module: "SwiftBokMacros", type: "PublicMembersMacro")

@attached(memberAttribute)
public macro InternalMembers() = #externalMacro(module: "SwiftBokMacros", type: "InternalMembersMacro")

@attached(member, names: arbitrary)
public macro Setter() = #externalMacro(module: "SwiftBokMacros", type: "SetterMacro")
