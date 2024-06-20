import SwiftBok
import Foundation

// MARK: - Init
@Init()
public struct Foo {
    let a: Int = 10
    var b: Bool
}

let f = Foo(b: false)

// MARK: - Members
@Members()
public struct Bar {
    public let a: Int
}

@Members(isPublic: false)
public struct Wow {
    let a: Int
}

// MARK: - Setter
@Setter()
class Member {
    var age: Int = 10
    var name: String = "10"
}

@Setter(isPublic: true)
class View {
    static let GONE = 1
    let id = UUID()
    var x: Int = 80
    var y: Int = 100
    
    func draw() {
        
    }
}

let member = Member()
    .age(10)
    .name("")

let view = View()
    .x(100)
    .y(30)
