//
//  QiscusManager.swift
//  QChat
//
//  Created by asharijuang on 8/24/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
import CocoaMQTT
import SwiftyJSON

// Qiscus wrapper
class QiscusRealtimeManager : NSObject{
    
    private static let instance = QiscusRealtimeManager()
    
    public static var shared:QiscusRealtimeManager {
        get {
            return instance
        }
    }
    
    var delegate    : QiscusRealtimeDelegate!
    var config      : QiscusRealtimeConfig!
    var mqtt        : CocoaMQTT?
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
    
    private override init() {
        super.init()
    }
    
    func mqttDisconnect(){
        if self.mqtt == nil {
            self.mqtt?.disconnect()
        }
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
        if self.participantEmail?.count != 0 && self.participantEmail != nil{
            for email in self.participantEmail! {
                self.mqtt?.unsubscribe("u/\(email)/s")
            }
        }
        
        if self.roomsPrivateChannel?.count != 0 && self.roomsPrivateChannel != nil{
            for roomId in self.roomsPrivateChannel! {
                self.mqtt?.unsubscribe("r/\(roomId)/\(roomId)/+/d")
                self.mqtt?.unsubscribe("r/\(roomId)/\(roomId)/+/r")
            }
        }
    }
    
    func unsubscribeRoomId(roomId : String){
        self.mqtt?.unsubscribe("r/\(roomId)/\(roomId)/+/d")
        self.mqtt?.unsubscribe("r/\(roomId)/\(roomId)/+/r")
    }
    
    
    func mqttConnect(){
        if self.mqtt == nil {
            var deviceID = "000"
            if let vendorIdentifier = UIDevice.current.identifierForVendor {
                deviceID = vendorIdentifier.uuidString
            }
            
            let clientID = "iosMQTT-\(config.appName)-\(deviceID)-\(config.qiscusClientID)"
            mqtt = CocoaMQTT(clientID: config.qiscusClientID!, host: config.hostRealtimeServer!, port: UInt16(config.port!))
            mqtt!.username = ""
            mqtt!.password = ""
            mqtt!.willMessage = CocoaMQTTWill(topic: "u/\(config.QiscusClientEmail)/s", message: "0")
            mqtt!.keepAlive = 60
            mqtt!.delegate = self
            mqtt!.enableSSL = false
        }
        
        self.mqtt?.connect()
    }
    
    func startPublishOnlineStatus(){
        if Thread.isMainThread{
            self.userStatusTimer?.invalidate()
            self.userStatusTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.publishOnlineStatus), userInfo: nil, repeats: true)
        }else{
            DispatchQueue.main.sync {
                self.userStatusTimer?.invalidate()
                self.userStatusTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.publishOnlineStatus), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func publishOnlineStatus(){
        let channel = "u/\(config.QiscusClientEmail)/s"
        let state = UIApplication.shared.applicationState
        let activeState = (state == .active)
        if activeState {
            self.mqtt?.publish(channel, withString: "1", qos: .qos1, retained: true)
        }
    }
    
    func stopPublishOnlineStatus(){
        let channel = "u/\(config.QiscusClientEmail)/s"
        self.userStatusTimer?.invalidate()
        self.mqtt?.publish(channel, withString: "0", qos: .qos1, retained: true)
    }
    
}

extension QiscusRealtimeManager: CocoaMQTTDelegate {
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        print("trust: \(trust)")
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("ack: \(ack)")
        let state = UIApplication.shared.applicationState
        let activeState = (state == .active)
        
        if ack == .accept {
            self.realtimeConnect = true
            
            let commentChannel = "\(config.token)/c"
            mqtt.subscribe(commentChannel, qos: .qos2)
            
            let eventChannel = "\(config.token)/n"
            mqtt.subscribe(eventChannel, qos: .qos2)
            
            if self.participantEmail?.count != 0 && self.participantEmail != nil{
                for email in self.participantEmail! {
                    mqtt.subscribe("u/\(email)/s")
                }
            }
            
            if self.roomsPrivateChannel?.count != 0 && self.roomsPrivateChannel != nil{
                for roomId in self.roomsPrivateChannel! {
                    mqtt.subscribe("r/\(roomId)/\(roomId)/+/t")
                    mqtt.subscribe("r/\(roomId)/\(roomId)/+/d")
                    mqtt.subscribe("r/\(roomId)/\(roomId)/+/r")
                }
            }
            
            if self.roomsPublicChannel?.count != 0 && self.roomsPublicChannel != nil{
                for uniqueId in self.roomsPublicChannel! {
                    mqtt.subscribe("\(config.qiscusClientID)/\(uniqueId)/c")
                }
            }
            
            if activeState {
                self.startPublishOnlineStatus()
            }
            
            self.mqtt = mqtt

        }
        
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        print("new state: \(state)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        if let messageData = message.string {
            let channelArr = message.topic.split(separator: "/")
            let lastChannelPart = String(channelArr.last!)
            switch lastChannelPart {
            case "n":
                let json = JSON(parseJSON:messageData)
                let roomId = "\(json["room_id"])"
                self.delegate.didReceiveMessageEvent(roomId: roomId, message: messageData)
                break
            case "c":
                let json = JSON(parseJSON:messageData)
                let roomId = "\(json["room_id"])"
                let commentId = json["id"].intValue
                let text      = json["message"].string ?? ""
                
                let commentType = json["type"].stringValue
                if commentType == "system_event" {
                    let payload = json["payload"]
                    let type = payload["type"].stringValue
                    if type == "remove_member" || type == "left_room"{
                        if payload["object_email"].stringValue == config.QiscusClientEmail {
                            self.unsubscribeRoomId(roomId: roomId)
                        }
                    }
                }
                
                self.delegate.didReceiveMessageComment(roomId: roomId, message: messageData)
                
                break
            case "t":
                let roomId = String(channelArr[2])
                let userEmail:String = String(channelArr[3])
                let data = (messageData == "0") ? "" : userEmail
                
                func startTypingNotification(){
                    DispatchQueue.main.async {
                        let typing = (messageData == "0") ? false : true
                        QiscusNotification.publish(userTyping: userEmail, roomId: roomId, typing: typing)
                        self.delegate.updateUserTyping(roomId: roomId,userEmail: data)
                    }
                }
                
                if userEmail != config.QiscusClientEmail {
                    startTypingNotification()
                }
                break
            case "d":
                let roomId = String(channelArr[2])
                let messageArr = messageData.split(separator: ":")
                let commentId = Int(String(messageArr[0]))!
                let userEmail = String(channelArr[3])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                    self.delegate.didReceiveMessageStatus(roomId: roomId, commentId: commentId, Status: .delivered)
                }
               
                break
            case "r":
                let roomId = String(channelArr[2])
                let messageArr = messageData.split(separator: ":")
                let commentUid = String(messageArr.last!)
                let commentId = Int(String(messageArr[0]))!
                let userEmail = String(channelArr[3])
                
                print("cek \(commentId)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                    self.delegate.didReceiveMessageStatus(roomId: roomId, commentId: commentId, Status: .read)
                }
                
                
                break
            case "s":
                let roomId = String(channelArr[2])
                let messageArr = messageData.split(separator: ":")
                if messageArr.count > 1 {
                    let userEmail = String(channelArr[1])
                    let presenceString = String(messageArr[0])
                    
                    if let timeToken = Double(String(messageArr[1])){
                        self.lastSeen = timeToken/1000
                        self.delegate.didReceiveUserStatus(roomId : roomId, userEmail: userEmail, timeString: lastSeenString, timeToken: timeToken)
                    }
                }
                
               
                break
            default:
                print( "Realtime socket receive message in unknown topic: \(message.topic)")
                break
            }
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("topic: \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("topic: \(topic)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("mqtt didPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("mqtt didReceivePong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("\(err?.localizedDescription)")
        self.realtimeConnect = false
        self.stopPublishOnlineStatus()
    }
}

