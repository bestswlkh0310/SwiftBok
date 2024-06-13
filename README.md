# PublicInitMacro
fork: https://github.com/SongSeoYoung/PublicInitMacro
thank you 🫡

## Install:
You can install it via SwiftPackageManager. 
```
https://github.com/bestswlkh0310/PublicInitMacro
```

## Usage:
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
