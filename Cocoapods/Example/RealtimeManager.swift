//
//  RealtimeManager.swift
//  example
//
//  Created by Qiscus on 27/08/18.
//  Copyright © 2018 qiscus. All rights reserved.
//

import Foundation
import QiscusRealtime

class RealtimeManager {
    static var shared : RealtimeManager = RealtimeManager()
    private var client : QiscusRealtime? = nil
    private var pendingSubscribeTopic : [RealtimeSubscribeEndpoint] = [RealtimeSubscribeEndpoint]()
    
    func setup(appName: String) {
        // make sure realtime client still single object
        if client != nil { return }
        let bundle = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        var deviceID = "00000000"
        if let vendorIdentifier = UIDevice.current.identifierForVendor {
            deviceID = vendorIdentifier.uuidString
        }
        let clientID = "iosMQTT-\(bundle)-\(deviceID)"
        let config = QiscusRealtimeConfig(appName: appName, clientID: clientID)
        client = QiscusRealtime.init(withConfig: config)
        QiscusRealtime.enableDebugPrint = true
    }
    
    func disconnect() {
        guard let c = client else {
            return
        }
        c.disconnect()
        self.pendingSubscribeTopic.removeAll()
    }
    
    /// Qiscus Realtime connect
    ///
    /// - Parameters:
    ///   - username: username
    ///   - password: Qiscus Token
    func connect(username: String, password: String) {
        guard let c = client else {
            return
        }
        c.connect(username: username, password: password, delegate: self)
        // subcribe user token to get new comment
        if !c.subscribe(endpoint: .comment(token: password)) {
            // subscribeNewComment(token: token)
            self.pendingSubscribeTopic.append(.comment(token: password))
        }
    }
    
    func subscribeRooms(rooms: [String]) {
        guard let c = client else {
            return
        }
        for room in rooms {
            // subscribe comment deliverd receipt
            if !c.subscribe(endpoint: .delivery(roomID: room)){
                print("failed to subscribe event deliver event from room \(room)")
            }
            // subscribe comment read
            if !c.subscribe(endpoint: .read(roomID: room)) {
                print("failed to subscribe event read from room \(room)")
            }
            if !c.subscribe(endpoint: .typing(roomID: room)) {
                print("failed to subscribe event typing from room \(room)")
            }
        }
        
    }
    
    func isTyping(_ value: Bool, roomID: String){
        guard let c = client else {
            return
        }
        if !c.publish(endpoint: .isTyping(value: value, roomID: roomID)) {
            print("failed to send typing to roomID \(roomID)")
        }
    }
    
    func isOnline(_ value: Bool) {
        guard let c = client else {
            return
        }
        if !c.publish(endpoint: .onlineStatus(value: value)) {
            print("failed to send Online status")
        }
    }
    
    func resumePendingSubscribeTopic() {
        guard let client = client else {
            return
        }
        // resume pending subscribe
        if !pendingSubscribeTopic.isEmpty {
            for (i,t) in pendingSubscribeTopic.enumerated().reversed() {
                // check if success subscribe
                if client.subscribe(endpoint: t) {
                    // remove from pending list
                    self.pendingSubscribeTopic.remove(at: i)
                }
            }
        }
    }
    
}

extension RealtimeManager: QiscusRealtimeDelegate {
    func didReceiveUser(userEmail: String, isOnline: Bool, timestamp: String) {

    }
    
    
    func didReceiveMessageStatus(roomId: String, commentId: String, commentUniqueId: String, Status: MessageStatus) {
        //
    }
    
    func didReceiveMessage(data: String) {
        
    }
    
    func didReceiveUser(typing: Bool, roomId: String, userEmail: String) {
        
    }
    
    func connectionState(change state: QiscusRealtimeConnectionState) {
        print("Qiscus realtime connection state \(state.rawValue)")
        if state == .connected {
            resumePendingSubscribeTopic()
            print("Qiscus realtime connected")
        }
    }
}
