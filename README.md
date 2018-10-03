# [QiscusRealtime](https://github.com/qiscus/QiscusRealtime-iOS) - Messaging and Chat Core API for iOS
[Qiscus](https://qiscus.com) Enable custom in-app messaging in your Mobile App and Web using Qiscus Chat SDK and Messaging API

[![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)](https://github.com/qiscus/QiscusRealtime-iOS)
[![Languages](https://img.shields.io/badge/language-Objective--C%20%7C%20Swift-orange.svg)](https://github.com/qiscus)
[![CocoaPods](https://img.shields.io/badge/pod-v3.0.109-green.svg)](https://github.com/qiscus/QiscusRealtime-iOS)



## Features

- [x] Config Realtime Server. 
- [x] Connect with username and qiscus token.
- [x] Publish typing and online status.
- [x] Subscribe(receive) new comment, online status, typing, deliverd and read comment.
- [x] [API Reference](https://qiscusrealtime.firebaseapp.com)

## Component Libraries

In order to keep QiscusRealtime focused specifically on realtime event implementation, additional libraries have been create by the [Qiscus IOS] (https://qiscus.com).

* [QiscusCore](https://github.com/qiscus) - Chat Core API, All chat functionality already on there.
* [QiscusUI](https://github.com/qiscus) - An chat component library, make it easy to custom your chat UI.
* [Qiscus](https://github.com/qiscus) - An chat sdk with complete feature, simple, easy to integrate.


## Installation

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate QiscusRealtime into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'QiscusRealtime',
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Setup client :

```
import QiscusRealtime

let clientID = "iosMQTT-userxyz"
let config = QiscusRealtimeConfig(appName: [appName], clientID: [clientID])
client = QiscusRealtime.init(withConfig: config)
```

### Connect to server :

```
client.connect(username: username, password: password, delegate: self)

```

### Subscribe to endnpoint or topic

```
if !client.subscribe(endpoint: .delivery(roomID: room.id)){
	self.pendingSubscribeTopic.append(.delivery(roomID: room.id))
	print("failed to subscribe event deliver event from room \(room.name), then queue in pending")
}
```

### Subcribe topics or endpoint :

```
enum RealtimeSubscribeEndpoint {
	 // new comment
    case comment(token: String)
    // publish online status
    case onlineStatus(user: String)
    // get typing inside room
    case typing(roomID: String)
    // delivery or receive comment inside room
    case delivery(roomID: String)
    // read comment inside room
    case read(roomID: String)
    // receive comment deleted
    case notification(token: String)
}
```

### Publish topics or endpoint :

```
enum RealtimePublishEndpoint {
    // publish online status
    case onlineStatus(value: Bool)
    // publish typing in room, typing by autenticate user
    case isTyping(value: Bool, roomID: String)
}
```

### Qiscus Realtime Delegate : 

```
public protocol QiscusRealtimeDelegate {
    /// Qiscus Realtime Server connection state
    ///
    /// - Parameter state: can be connection, connected, or disconnect
    func connectionState(change state: QiscusRealtimeConnectionState)
    
    /// You will receive from qiscus realtime about user status
    ///
    /// - Parameters:
    ///   - userEmail: qiscus email
    ///   - timestamp: timestampt in UTC
    func didReceiveUser(userEmail: String, isOnline: Bool, timestamp: String)
    
    // MARK: TODO minor feature, waiting core can delete, parsing payload to complicated
    /// You will receive message from qiscus realtime about event like message delete, after you got this message
    ///
    /// - Parameters:
    ///   - roomId: roomId String
    ///   - message: message
    //func didReceiveMessageEvent(roomId: String, message: String)
    
    /// You will receive message from qiscus realtime about comment like new comment, user left room, remove member and other
    ///
    /// - Parameters:
    ///   - data: message as string JSON
    func didReceiveMessage(data: String)
    
    /// you will receive Message comment status
    /// - Parameters:
    ///   - roomId: roomId
    ///   - commentId: commentId
    ///   - Status: status read or deliver
    func didReceiveMessageStatus(roomId: String, commentId: String, commentUniqueId: String, Status: MessageStatus)
    
    /// You will receive message from qiscus realtime about user typing
    ///
    /// - Parameters:
    ///   - roomId: roomId (String)
    ///   - userEmail: userEmail (String)
    func didReceiveUser(typing: Bool, roomId: String, userEmail: String)
}
```

### Log or Activate Debug :

To activate print log, every activity should be print in console log.

```
QiscusRealtime.enableDebugPrint = true
```


### Security Disclosure

If you believe you have identified a security vulnerability with QiscusRealtime, you should report it as soon as possible via email to juang@qiscus.co. Please do not post it to a public issue.


## FAQ

### When we use Qiscus

intead Qiscus?

QiscusCore is lite version chat sdk, if you wan't to build your own chat ui best option is use QiscusCore. But, if you need in App chat quickly use Qiscus Chat SDK(build in UI and simple configuration). please visit [Qiscus](https://github.com/qiscus/qiscus-sdk-ios) to use qiscus chat sdk.


