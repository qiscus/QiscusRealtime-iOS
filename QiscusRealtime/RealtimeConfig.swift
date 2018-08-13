//
//  RealtimeConfig.swift
//  QiscusRealtime
//
//  Created by Qiscus on 09/08/18.
//

import Foundation

public enum MessageStatus:Int{
    case read
    case delivered
}

struct QiscusRealtimeUser {
    let email       : String
    let token       : String
    let deviceID    : String
}

public struct QiscusRealtimeConfig {
    public let appName                    : String
    public var clientID                   : String
    public var hostRealtimeServer         : String = "mqtt.qiscus.com"
    public var port                       : UInt16 = 1883
    public var QiscusClientRealtimeSSL    : Bool = true
    
    public init(appName name: String, clientID id: String) {
        appName = name
        clientID = id
    }
    
    public init(appName name: String, clientID id: String, host h: String, port p: UInt16) {
        appName             = name
        clientID            = id
        hostRealtimeServer  = h
        port                = p
    }
}

//open class QiscusRealtimeConfig : NSObject {
//    internal var appName                    : String
////    internal var token                      : String
////    internal var QiscusClientEmail          : String
//    internal var qiscusClientID             : String? = "3657668"
//    internal var hostRealtimeServer         : String? = "mqtt.qiscus.com"
//    internal var port                       : Int? = 1883
//    internal var QiscusClientRealtimeSSL    : Bool
//
//    /// init Qiscus realtime config
//    ///
//    /// - Parameters:
//    ///   - name: appName
//    ///   - qiscusClientID: this param default qiscusClientID = 3657668
//    ///   - token: token Qiscus
//    ///   - QiscusClientEmail: your qiscusclientEmail you can get this after login qiscus
//    ///   - hostRealtimeServer: this param default mqtt.qiscus.com
//    ///   - port: this param default 1883
//    ///   - QiscusClientRealtimeSSL: this param default is false
//    public init(appName name: String, qiscusClientID: String? = nil, token:String, QiscusClientEmail: String, hostRealtimeServer : String? = nil, port: Int? = nil, QiscusClientRealtimeSSL: Bool = false) {
//        self.appName                    = name
////        self.token                      = token
////        self.QiscusClientEmail          = QiscusClientEmail
//        if (qiscusClientID != nil){
//            self.qiscusClientID             = qiscusClientID
//        }
//        if (hostRealtimeServer != nil){
//            self.hostRealtimeServer         = hostRealtimeServer!
//        }
//
//        if(port != nil){
//            self.port                       = port!
//        }
//
//        self.QiscusClientRealtimeSSL    = QiscusClientRealtimeSSL
//    }
//}
