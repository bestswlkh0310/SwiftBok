import SwiftBok

// MARK: - Init
@PublicInit
public struct Foo {
    let a: Int = 10
    var b: Bool
}

let f = Foo(b: false)

// MARK: - Members
@PublicMembers
public struct Bar {
    public let a: Int
}

@InternalMembers
public struct Wow {
    let a: Int
}

// MARK: - Setter
@Setter
class Member {
    var age: Int = 10
    var name: String = "10"
    
}
let member = Member()
    .age(10)
    .name("")
print(member)
