@attached(member, names: named(init))
public macro PublicInit() = #externalMacro(module: "SwiftBokMacros", type: "PublicInitMacro")

@attached(member, names: named(init))
public macro InternalInit() = #externalMacro(module: "SwiftBokMacros", type: "InternalInitMacro")
