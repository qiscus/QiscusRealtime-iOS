//
//  mqttLib.swift
//  mqttLib
//
//  Created by asharijuang on 03/08/18.
//  Copyright © 2018 qiscus. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol QiscusRealtimeDelegate {
    
    /// You will receive from qiscus realtime about user status
    ///
    /// - Parameters:
    ///   - roomId: roomId
    ///   - userEmail: userEmail
    ///   - timeString: timeString
    ///   - timeToken: timeToken
    func didReceiveUserStatus(roomId: String, userEmail: String, timeString: String, timeToken: Double)
    
    /// You will receive message from qiscus realtime about event like message delete, after you got this message
    ///
    /// - Parameters:
    ///   - roomId: roomId String
    ///   - message: message
    func didReceiveMessageEvent(roomId: String, message: String)
    
    /// You will receive message from qiscus realtime about comment like new comment, user left room, remove member and other
    ///
    /// - Parameters:
    ///   - roomId: roomId String
    ///   - message: message
    func didReceiveMessageComment(roomId: String, message: String)
    
    
    /// you will receive Message comment status
    /// - Parameters:
    ///   - roomId: roomId
    ///   - commentId: commentId
    ///   - Status: status read or deliver
    func didReceiveMessageStatus(roomId: String, commentId: Int, Status: MessageStatus)
    
   
    /// You will receive message from qiscus realtime about user typing
    ///
    /// - Parameters:
    ///   - roomId: roomId (String)
    ///   - userEmail: userEmail (String)
    func updateUserTyping(roomId: String, userEmail: String)
    
}
public enum MessageStatus:Int{
    case read
    case delivered
}
open class QiscusRealtimeConfig : NSObject {
    internal var appName                    : String
    internal var token                      : String
    internal var QiscusClientEmail          : String
    internal var qiscusClientID             : String? = "3657668"
    internal var hostRealtimeServer         : String? = "mqtt.qiscus.com"
    internal var port                       : Int? = 1883
    internal var QiscusClientRealtimeSSL    : Bool
    
    /// init Qiscus realtime config
    ///
    /// - Parameters:
    ///   - name: appName
    ///   - qiscusClientID: this param default qiscusClientID = 3657668
    ///   - token: token Qiscus
    ///   - QiscusClientEmail: your qiscusclientEmail you can get this after login qiscus
    ///   - hostRealtimeServer: this param default mqtt.qiscus.com
    ///   - port: this param default 1883
    ///   - QiscusClientRealtimeSSL: this param default is false
    public init(appName name: String, qiscusClientID: String? = nil, token:String, QiscusClientEmail: String, hostRealtimeServer : String? = nil, port: Int? = nil, QiscusClientRealtimeSSL: Bool = false) {
        self.appName                    = name
        self.token                      = token
        self.QiscusClientEmail          = QiscusClientEmail
        if (qiscusClientID != nil){
            self.qiscusClientID             = qiscusClientID
        }
        if (hostRealtimeServer != nil){
            self.hostRealtimeServer         = hostRealtimeServer!
        }
        
        if(port != nil){
            self.port                       = port!
        }
        
        self.QiscusClientRealtimeSSL    = QiscusClientRealtimeSSL
    }
}

public class QiscusRealtimeLib: NSObject {
    
    var qiscusRealtimeManager = QiscusRealtimeManager.shared
    
    class var bundle:Bundle{
        get{
            let podBundle   = Bundle(for: QiscusRealtimeLib.self)
            
            if let bundleURL = podBundle.url(forResource: "QiscusRealtimeLib", withExtension: "bundle") {
                return Bundle(url: bundleURL)!
            }else{
                return podBundle
            }
        }
    }
    
    /// this func to init QiscusRealtimeLib
    ///
    /// - Parameters:
    ///   - config: need to set config QiscusRealtimeConfig
    ///   - delegate
    public init(withConfig config: QiscusRealtimeConfig, delegate: QiscusRealtimeDelegate? = nil) {
        qiscusRealtimeManager.config      = config
        qiscusRealtimeManager.delegate    = delegate
    }
    
    
    /// this func to connect qiscus realtime
    public func qiscusRealtimeConnect(delegate: QiscusRealtimeDelegate? = nil){
        qiscusRealtimeManager.delegate    = delegate
        return qiscusRealtimeManager.mqttConnect()
    }
    
//    public func setDelegateQiscusRealtime(){
//        delegate: QiscusRealtimeDelegate? = nil
//    }
    
    
    /// this func to setup realtime room private
    ///
    /// - Parameter roomId: array of roomId [String]
    public func setupRealtimeRoomPrivate(roomId: [String]? = nil){
        return qiscusRealtimeManager.setupRoomPrivate(roomId: roomId)
    }
    
    
    /// this func to setup realtime room public
    ///
    /// - Parameter roomUniqueId: array of roomUniqueId [String]
    public func setupRealtimeRoomPublic(roomUniqueId:  [String]? = nil){
        return qiscusRealtimeManager.setupRoomPublic(roomUniqueId: roomUniqueId)
    }
    
    /// this func to setup participant subcribe
    ///
    /// - Parameter roomUniqueId: array of participantEmail [String]
    public func setupParticipantSubcribe(participantEmail:  [String]? = nil){
        return qiscusRealtimeManager.setupParticipantSubcribe(participantEmail: participantEmail)
    }
    
    
    /// this func to unsubcribeRoomChannel
    public func unsubscribeRoomChannel(){
        return qiscusRealtimeManager.unsubscribeRoomChannel()
    }
    
    
    /// this func to disconnect qiscus realtime
    public func qiscusRealtimeDisconnect(){
        return qiscusRealtimeManager.mqttDisconnect()
    }
}
