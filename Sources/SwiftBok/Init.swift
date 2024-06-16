@attached(member, names: named(init))
public macro PublicInit() = #externalMacro(module: "SwiftBokMacros", type: "PublicInitMacro")
