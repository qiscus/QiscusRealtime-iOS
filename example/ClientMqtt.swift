//
//  ClientMqtt.swift
//  example
//
//  Created by asharijuang on 03/08/18.
//  Copyright © 2018 qiscus. All rights reserved.
//

import Foundation
import mqttLib
import SwiftyJSON

class ClientMqtt : NSObject {
    
    private var client : QiscusRealtimeLib!
    
    var appName                 = "Kiwari"
    var deviceID                = "A56B0E70-A082-426C-90B7-233A1BCFFA11"
    var qiscusClientID          = "3657668"
    var hostRealtimeServer      = "mqtt.qiscus.com"
    var port                    = 1883
    var QiscusClientEmail       = "userid_8898_628681011193@kiwari-prod.com"
    var QiscusClientRealtimeSSL = false
    var token = "0mthTZCsFNbz8ju2QtJ0"
    var roomId = 947598
    
    override init() {
        super.init()
        let config  = QiscusRealtimeConfig.init(appName: appName, qiscusClientID: qiscusClientID, token: token, QiscusClientEmail: QiscusClientEmail, hostRealtimeServer: hostRealtimeServer, port: port, QiscusClientRealtimeSSL: QiscusClientRealtimeSSL)
        self.client = QiscusRealtimeLib.init(withConfig: config)
    }
    
    func setupRealtimeRoomPrivate(roomId: [String]){
        client.setupRealtimeRoomPrivate(roomId: roomId)
    }
    
    func setupRealtimeRoomPublic(roomUniqueId: [String]){
        client.setupRealtimeRoomPublic(roomUniqueId:roomUniqueId)
    }
    
    func setupParticipantSubcribe(participantEmail: [String]){
         client.setupParticipantSubcribe(participantEmail: participantEmail)
    }
    
    func qiscusRealtimeConnect(delegate: QiscusRealtimeDelegate? = nil){
        client.qiscusRealtimeConnect(delegate: delegate)
    }
    
    func qiscusRealtimeDisconnet(){
        client.qiscusRealtimeDisconnect()
    }
    
    func unsubscribeRoomChannel(){
        client.unsubscribeRoomChannel()
    }
    
}
