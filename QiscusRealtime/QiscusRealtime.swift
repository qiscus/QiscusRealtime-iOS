//
//  mqttLib.swift
//  mqttLib
//
//  Created by asharijuang on 03/08/18.
//  Copyright © 2018 qiscus. All rights reserved.
//

import Foundation
import SwiftyJSON

public class QiscusRealtime {
    private let manager : QiscusRealtimeManager
    public static var enableDebugPrint: Bool = false
    public var isConnect : Bool {
        return manager.isConnected
    }
    class var bundle:Bundle{
        get{
            let podBundle   = Bundle(for: QiscusRealtime.self)
            
            if let bundleURL = podBundle.url(forResource: "QiscusRealtime", withExtension: "bundle") {
                return Bundle(url: bundleURL)!
            }else{
                return podBundle
            }
        }
    }
    
    /// this func to init QiscusRealtime
    ///
    /// - Parameters:
    ///   - config: need to set config QiscusRealtimeConfig
    ///   - delegate
    public init(withConfig config: QiscusRealtimeConfig) {
        manager = QiscusRealtimeManager(withConfig: config)
    }
    
    /// Connect to qiscus realtime server
    ///
    /// - Parameters:
    ///   - username: qiscus user email
    ///   - password: qiscus token
    ///   - delegate: set delegate to get the event
    public func connect(username: String, password: String, delegate: QiscusRealtimeDelegate? = nil){
        manager.connect(username: username, password: password, delegate: delegate)
    }
    
    public func subscribe(endpoint: RealtimeSubscribeEndpoint) -> Bool {
        return manager.subscribe(type: endpoint)
    }
    
    /// this func to setup realtime room private
    ///
    /// - Parameter roomId: array of roomId [String]
    public func setupRealtimeRoomPrivate(roomId: [String]? = nil){
//        return qiscusRealtimeManager.setupRoomPrivate(roomId: roomId)
    }
    
    
    /// this func to setup realtime room public
    ///
    /// - Parameter roomUniqueId: array of roomUniqueId [String]
    public func setupRealtimeRoomPublic(roomUniqueId:  [String]? = nil){
//        return qiscusRealtimeManager.setupRoomPublic(roomUniqueId: roomUniqueId)
    }
    
    /// this func to setup participant subcribe
    ///
    /// - Parameter roomUniqueId: array of participantEmail [String]
    public func setupParticipantSubcribe(participantEmail:  [String]? = nil){
//        return qiscusRealtimeManager.setupParticipantSubcribe(participantEmail: participantEmail)
    }
    
    
    /// this func to unsubcribeRoomChannel
//    public func unsubscribeRoomChannel(){
////        return qiscusRealtimeManager.unsubscribeRoomChannel()
//    }
    
    
    /// this func to disconnect qiscus realtime
    public func disconnect(){
//        return qiscusRealtimeManager.mqttDisconnect()
    }
}
