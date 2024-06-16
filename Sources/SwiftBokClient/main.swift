import SwiftBok

@PublicInit
public struct Foo {
    let a: Int = 10
    var b: Bool
}

let f = Foo(b: false)

@PublicMembers
public struct Bar {
    public let a: Int
}

@InternalMembers
public struct Wow {
    let a: Int
}
