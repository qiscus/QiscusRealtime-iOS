//
//  MqttClient.swift
//  QiscusCore
//
//  Created by Qiscus on 09/08/18.
//

import Foundation
import CocoaMQTT

enum realtimeTopic {
    case comment(token: String)
    case typing(roomId: String,userId: String)
}

class MqttClient {
    var client    : CocoaMQTT
    var connectionState : QiscusRealtimeConnectionState = .disconnected
    var isConnect : Bool {
        get {
            if connectionState == .connected {
                return true
            }else {
                return false
            }
        }
    }
    
    init(clientID: String, host: String, port: UInt16) {
        client = CocoaMQTT.init(clientID: clientID, host: host, port: port)
    }
    
    func connect(username: String, password: String) -> Bool {
        client.username = username
        client.password = password
//        client.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        client.keepAlive = 60
        client.delegate = self
        return client.connect()
    }
    
    func publish(_ topic: String, message: String) {
        client.publish(topic, withString: message)
    }
    
    func subscribe(_ topic: String) {
        client.subscribe(topic, qos: .qos0)
    }
    
    func unsubscribe(_ topic: String) {
        client.unsubscribe(topic)
    }
    
    func disconnect(){
        self.client.disconnect()
    }
}

extension MqttClient: CocoaMQTTDelegate {
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        let state = UIApplication.shared.applicationState
        let activeState = (state == .active)
        
//        if ack == .accept {
//            self.realtimeConnect = true
//
//            let commentChannel = "\(config.token)/c"
//            mqtt.subscribe(commentChannel, qos: .qos2)
//
//            let eventChannel = "\(config.token)/n"
//            mqtt.subscribe(eventChannel, qos: .qos2)
//
//            if self.participantEmail?.count != 0 && self.participantEmail != nil{
//                for email in self.participantEmail! {
//                    mqtt.subscribe("u/\(email)/s")
//                }
//            }
//
//            if self.roomsPrivateChannel?.count != 0 && self.roomsPrivateChannel != nil{
//                for roomId in self.roomsPrivateChannel! {
//                    mqtt.subscribe("r/\(roomId)/\(roomId)/+/t")
//                    mqtt.subscribe("r/\(roomId)/\(roomId)/+/d")
//                    mqtt.subscribe("r/\(roomId)/\(roomId)/+/r")
//                }
//            }
//
//            if self.roomsPublicChannel?.count != 0 && self.roomsPublicChannel != nil{
//                for uniqueId in self.roomsPublicChannel! {
//                    mqtt.subscribe("\(config.qiscusClientID)/\(uniqueId)/c")
//                }
//            }
//
//            if activeState {
//                self.startPublishOnlineStatus()
//            }
//
//            self.mqtt = mqtt
//
//        }
        
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        self.connectionState = QiscusRealtimeConnectionState(rawValue: state.description)!
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
//        if let messageData = message.string {
//            let channelArr = message.topic.split(separator: "/")
//            let lastChannelPart = String(channelArr.last!)
//            switch lastChannelPart {
//            case "n":
//                let json = JSON(parseJSON:messageData)
//                let roomId = "\(json["room_id"])"
//                self.delegate.didReceiveMessageEvent(roomId: roomId, message: messageData)
//                break
//            case "c":
//                let json = JSON(parseJSON:messageData)
//                let roomId = "\(json["room_id"])"
//                let commentId = json["id"].intValue
//                let text      = json["message"].string ?? ""
//
//                let commentType = json["type"].stringValue
//                if commentType == "system_event" {
//                    let payload = json["payload"]
//                    let type = payload["type"].stringValue
//                    if type == "remove_member" || type == "left_room"{
//                        if payload["object_email"].stringValue == config.QiscusClientEmail {
//                            self.unsubscribeRoomId(roomId: roomId)
//                        }
//                    }
//                }
//
//                self.delegate.didReceiveMessageComment(roomId: roomId, message: messageData)
//
//                break
//            case "t":
//                let roomId = String(channelArr[2])
//                let userEmail:String = String(channelArr[3])
//                let data = (messageData == "0") ? "" : userEmail
//
//                func startTypingNotification(){
//                    DispatchQueue.main.async {
//                        let typing = (messageData == "0") ? false : true
//                        QiscusNotification.publish(userTyping: userEmail, roomId: roomId, typing: typing)
//                        self.delegate.updateUserTyping(roomId: roomId,userEmail: data)
//                    }
//                }
//
//                if userEmail != config.QiscusClientEmail {
//                    startTypingNotification()
//                }
//                break
//            case "d":
//                let roomId = String(channelArr[2])
//                let messageArr = messageData.split(separator: ":")
//                let commentId = Int(String(messageArr[0]))!
//                let userEmail = String(channelArr[3])
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
//                    self.delegate.didReceiveMessageStatus(roomId: roomId, commentId: commentId, Status: .delivered)
//                }
//
//                break
//            case "r":
//                let roomId = String(channelArr[2])
//                let messageArr = messageData.split(separator: ":")
//                let commentUid = String(messageArr.last!)
//                let commentId = Int(String(messageArr[0]))!
//                let userEmail = String(channelArr[3])
//
//                print("cek \(commentId)")
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
//                    self.delegate.didReceiveMessageStatus(roomId: roomId, commentId: commentId, Status: .read)
//                }
//
//
//                break
//            case "s":
//                let roomId = String(channelArr[2])
//                let messageArr = messageData.split(separator: ":")
//                if messageArr.count > 1 {
//                    let userEmail = String(channelArr[1])
//                    let presenceString = String(messageArr[0])
//
//                    if let timeToken = Double(String(messageArr[1])){
//                        self.lastSeen = timeToken/1000
//                        self.delegate.didReceiveUserStatus(roomId : roomId, userEmail: userEmail, timeString: lastSeenString, timeToken: timeToken)
//                    }
//                }
//
//
//                break
//            default:
//                print( "Realtime socket receive message in unknown topic: \(message.topic)")
//                break
//            }
//        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
//        print("topic: \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
//        print("topic: \(topic)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
//        print("mqtt didPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
//        print("mqtt didReceivePong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
//        print("\(err?.localizedDescription)")
//        self.realtimeConnect = false
//        self.stopPublishOnlineStatus()
    }
}
