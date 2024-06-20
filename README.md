# SwiftBok

## Install:
You can install it via SwiftPackageManager. 
```
https://github.com/bestswlkh0310/SwiftBok
```

## Usage:
### @Init(isPublic: Bool = true)
  
- default is public initializer
- struct only
```swift
@Init()
public struct Foo {
    let a: Int = 10
    var b: Bool
}

@Init(isPublic: false)
struct Canvas {
    let width: Int
    let height: Int
}

let f = Foo(b: false)
let canvas = Canvas(width: 1600, height: 900)
```
expands the following code:
```swift
public struct Foo {
    let a: Int = 10
    var b: Bool
    public init(
        b: Bool
    ) {
        self.b = b
    }
}

struct Canvas {
    let width: Int
    let height: Int
    init(
        width: Int,
        height: Int
    ) {
        self.width = width
        self.height = height
    }
}
```

---

### @Members(isPublic: Bool = true)

- default is public members
- struct/class only
```swift
@Members()
public struct Bar {
    public let a: Int
    let b: String // Error: @Members can only be applied to public
}

@Members(isPublic: false)
public struct Wow {
    let a: Int
    public b: String // Error: @Members can only be applied to internal
}
```

---


### @Setter(isPublic: Bool = false)

- default is internal setter
- struct/class only
```swift
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
```
expands the following code:
```swift
class Member {
    var age: Int = 10
    var name: String = "10"
    func age(_ age: Int) -> Member {
        self.age = age
        return self
    }

    func name(_ name: String) -> Member {
        self.name = name
        return self
    }
}

class View {
    static let GONE = 1
    let id = UUID()
    var x: Int = 80
    var y: Int = 100
    
    func draw() {
        
    }

    public func x(_ x: Int) -> View {
        self.x = x
        return self
    }

    public func y(_ y: Int) -> View {
        self.y = y
        return self
    }
}
```
