//
//  QiscusManager.swift
//  QChat
//
//  Created by asharijuang on 8/24/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol QREndpoint {
    var topic   : String { get }
    var payload : String { get }
}


public enum RealtimeEndpoint {
    case comment(token: String)
    case typing(roomID: String, userEmail: String?)
}

extension RealtimeEndpoint: QREndpoint {
    var topic: String {
        switch self {
        case .comment(let token):
            return "\(token)/c"
        case .typing(let roomID, _):
            return "r/\(roomID)/\(roomID)/+/t"
        }
    }
    
    var payload: String {
        switch self {
        case .typing(let roomID, let user):
            return "r/\(roomID)/\(roomID)/\(user ?? "")/t"
        default:
            return ""
        }
    }

}

class QRRouter<QREndpoint,MqttClient> {
    func subcribe() {
        
    }
    
    func publish() {
        
    }
}

struct RealtimeSubscriber {
    static func topic(endpoint: RealtimeEndpoint) -> String {
        switch endpoint {
        case .comment(let token):
            return "\(token)/c"
        case .typing(let roomID, _):
            return "r/\(roomID)/\(roomID)/+/t"
        }
    }
}

struct RealtimePublisher {
    static func payload(endpoint: RealtimeEndpoint) -> String{
        switch endpoint {
        case .typing(let roomID, let user):
            return "r/\(roomID)/\(roomID)/\(user)/t"
        default:
            break
        }
    }
}

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
    
    func publish(type: RealtimeEndpoint) {
        switch type {
        case .typing(_, _):
            let topic = RealtimeSubscriber.topic(endpoint: type)
            let payload = RealtimePublisher.payload(endpoint: type)
            mqttClient.publish(topic, message: payload)
        default:
            break
        }
    }
    
    func subscribe(type: RealtimeEndpoint) {
        let topic = RealtimeSubscriber.topic(endpoint: type)
        mqttClient.subscribe(topic)
    }
    
    func unsubscribe(type: RealtimeEndpoint) {
        let topic = RealtimeSubscriber.topic(endpoint: type)
        mqttClient.subscribe(topic)
    }

    func connect(username: String, password: String, delegate: QiscusRealtimeDelegate? = nil){
        self.delegate = delegate
        let connecting = mqttClient.connect(username: username, password: password)
        if connecting {
            self.user   = QiscusRealtimeUser(email: username, token: password, deviceID: "")
        }
    }
}



