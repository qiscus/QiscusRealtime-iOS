//
//  File.swift
//  qisme
//
//  Created by qiscus on 12/22/16.
//  Copyright © 2016 qiscus. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import QiscusRealtime

class MainApp {
    public static let shared = MainApp()
    var appDelegate : AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    private var mqttService     : ClientMqtt!
    
    private init() {
    }
    
    func initModul(){
        mqttService     = ClientMqtt()
    }
    
    func setupRealtimeRoomPrivate(roomId: [String]){
        self.mqttService.setupRealtimeRoomPrivate(roomId: roomId)
    }
    
    func setupRealtimeRoomPublic(roomUniqueId: [String]){
        self.mqttService.setupRealtimeRoomPublic(roomUniqueId: roomUniqueId)
    }
    
    func setupParticipantSubcribe(participantEmail: [String]){
        self.mqttService.setupParticipantSubcribe(participantEmail: participantEmail)
    }
    
    func qiscusRealtimeConnect(delegate: QiscusRealtimeDelegate? = nil){
        self.mqttService.qiscusRealtimeConnect(delegate: delegate)
    }
    
    func qiscusRealtimeDisconnet(){
        self.mqttService.qiscusRealtimeDisconnet()
    }
    
    func unsubscribeRoomChannel(){
        self.mqttService.unsubscribeRoomChannel()
    }
    
}
