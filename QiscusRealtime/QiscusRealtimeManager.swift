//
//  QiscusManager.swift
//  QChat
//
//  Created by asharijuang on 8/24/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
import SwiftyJSON

// Qiscus wrapper
class QiscusRealtimeManager {
    var delegate    : QiscusRealtimeDelegate? = nil
    var config      : QiscusRealtimeConfig!
    var user        : QiscusRealtimeUser?   = nil
    var mqttClient  : MqttClient!
    var isConnected   : Bool {
        get {
            return mqttClient.isConnect
        }
    }
    
    var userStatusTimer: Timer?
    var realtimeConnect: Bool = false
    var roomsPrivateChannel : [String]? = nil
    var roomsPublicChannel : [String]? = nil
    var participantEmail : [String]? = nil
    var lastSeen : Double = 0
    public var lastSeenString:String{
        get{
            if lastSeen == 0 {
                return ""
            }else{
                var result = ""
                let date = Date(timeIntervalSince1970: self.lastSeen)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMMM yyyy"
                let dateString = dateFormatter.string(from: date)
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a"
                let timeString = timeFormatter.string(from: date)
                
                let now = Date()
                
                let secondDiff = now.offsetFromInSecond(date: date)
                let minuteDiff = Int(secondDiff/60)
                let hourDiff = Int(minuteDiff/60)
                
                if secondDiff < 60 {
                    result = "FEW_SECOND_AGO"
                }
                else if minuteDiff == 1 {
                    result = "A_MINUTE_AGO"
                }
                else if minuteDiff < 60 {
                    result = "\(Int(secondDiff/60)) MINUTES_AGO"
                }else if hourDiff == 1{
                    result = "AN_HOUR_AGO"
                }else if hourDiff < 6 {
                    result = "\(hourDiff) HOURS_AGO"
                }
                else if date.isToday{
                    result = "\(timeString) HOURS_AGO"
                }
                else if date.isYesterday{
                    result = "\(timeString) YESTERDAY_AT"
                }
                else{
                    result = "\(dateString) " + "AT" + " \(timeString)"
                }
                
                return result
            }
        }
    }
    
    init(withConfig c: QiscusRealtimeConfig) {
        config      = c
        mqttClient  = MqttClient(clientID: c.clientID, host: c.hostRealtimeServer, port: c.port)
    }
    
    func disconnect(){
        mqttClient.disconnect()
    }
    
    func setupRoomPrivate(roomId: [String]? = nil){
        self.roomsPrivateChannel = roomId
    }
    
    func setupRoomPublic(roomUniqueId: [String]? = nil){
        self.roomsPublicChannel  = roomUniqueId
    }
    
    func setupParticipantSubcribe(participantEmail: [String]? = nil){
        self.participantEmail  = participantEmail
    }
    
    func unsubscribeRoomChannel(){
//        if self.participantEmail?.count != 0 && self.participantEmail != nil{
//            for email in self.participantEmail! {
//                self.mqtt?.unsubscribe("u/\(email)/s")
//            }
//        }
//
//        if self.roomsPrivateChannel?.count != 0 && self.roomsPrivateChannel != nil{
//            for roomId in self.roomsPrivateChannel! {
//                self.mqtt?.unsubscribe("r/\(roomId)/\(roomId)/+/d")
//                self.mqtt?.unsubscribe("r/\(roomId)/\(roomId)/+/r")
//            }
//        }
    }
    
    func unsubscribeRoomId(roomId : String){
//        self.mqtt?.unsubscribe("r/\(roomId)/\(roomId)/+/d")
//        self.mqtt?.unsubscribe("r/\(roomId)/\(roomId)/+/r")
    }
    
    
    func connect(username: String, password: String, delegate: QiscusRealtimeDelegate? = nil){
        self.delegate = delegate
        let connecting = mqttClient.connect(username: username, password: password)
        if connecting {
            self.user   = QiscusRealtimeUser(email: username, token: password, deviceID: "")
        }
    }
    
    func startPublishOnlineStatus(){
//        if Thread.isMainThread{
//            self.userStatusTimer?.invalidate()
//            self.userStatusTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.publishOnlineStatus), userInfo: nil, repeats: true)
//        }else{
//            DispatchQueue.main.sync {
//                self.userStatusTimer?.invalidate()
//                self.userStatusTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.publishOnlineStatus), userInfo: nil, repeats: true)
//            }
//        }
    }
    
    @objc func publishOnlineStatus(){
//        let channel = "u/\(config.QiscusClientEmail)/s"
//        let state = UIApplication.shared.applicationState
//        let activeState = (state == .active)
//        if activeState {
//            self.mqtt?.publish(channel, withString: "1", qos: .qos1, retained: true)
//        }
    }
    
    func stopPublishOnlineStatus(){
//        let channel = "u/\(config.QiscusClientEmail)/s"
//        self.userStatusTimer?.invalidate()
//        self.mqtt?.publish(channel, withString: "0", qos: .qos1, retained: true)
    }
    
}



