# ASCApi

### Introduction

An App-Store-Connect-Api implement based on Vapor that is A server-side Swift web framework.

### Usage

In `configure.swift`, Initialize using the code below In add above code: 
```swift
if let kid = Environment.get("kid"),
        let iss = Environment.get("iss"),
        let keyPath = Environment.get("keyPath") {
        try ASCApiManager.default.startService(iss: iss, kid: kid, keyPath: keyPath)
}
```
Used In the `Controller` functions：
```swift
let api = UserApi()
let userResponse: Future<UserListResponse> = api.getUserList(on: req)
```
### LIENCE
The Project is under the [MIT license](https://github.com/Tuluobo/app-store-connect/blob/master/LICENSE).

