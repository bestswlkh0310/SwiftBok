@attached(member, names: named(init))
public macro Init(isPublic: Bool = true) = #externalMacro(module: "SwiftBokMacros", type: "InitMacro")

@attached(memberAttribute)
public macro Members(isPublic: Bool = true) = #externalMacro(module: "SwiftBokMacros", type: "MembersMacro")

@attached(member, names: arbitrary)
public macro Setter(isPublic: Bool = false) = #externalMacro(module: "SwiftBokMacros", type: "SetterMacro")

@attached(member, names: named(toString))
public macro ToString() = #externalMacro(module: "SwiftBokMacros", type: "ToStringMacro")
