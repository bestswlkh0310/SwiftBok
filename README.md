# SwiftBok

## Install:
You can install it via SwiftPackageManager. 
```
https://github.com/bestswlkh0310/SwiftBok
```

## Usage:
- @PublicInit
```swift
@PublicInit
public struct TestStruct {
    private let a: String?
    public let b: Float? = nil
    var c: Int?
    var d: Int? = nil
}
```
expands the following code:
```swift
public struct TestStruct {
    private let a: String?
    public let b: Float? = nil
    var c: Int?
    var d: Int? = nil

    public init(a: String?, c: Int? = nil, d: Int? = nil) {
        self.a = a
        self.c = c
        self.d = d
    }
}
```
---
- @InternalInit
```swift
@InternalInit
public struct TestStruct {
    private let a: String?
    public let b: Float? = nil
    var c: Int?
    var d: Int? = nil
}
```
expands the following code:
```swift
public struct TestStruct {
    private let a: String?
    public let b: Float? = nil
    var c: Int?
    var d: Int? = nil

    init(a: String?, c: Int? = nil, d: Int? = nil) {
        self.a = a
        self.c = c
        self.d = d
    }
}
```
---
- @PublicMembers
```swift
@PublicMembers
public struct TestStruct {
    public let a: String?
    public let b: Float? = nil
    public var c: Int?
    var d: Int? = nil // Error: @PublicMembers can only be applied to public
}
```
---
- @InternalMembers
```swift
@InternalMembers
public struct TestStruct {
    let a: String?
    let b: Float? = nil
    var c: Int?
    public var d: Int? = nil // Error: @InternalMembers can only be applied to internal
}
```
