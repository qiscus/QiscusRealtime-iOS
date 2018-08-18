//
//  Protocol.swift
//  QiscusRealtime
//
//  Created by Qiscus on 09/08/18.
//

import Foundation


public enum QiscusRealtimeConnectionState : String{
    case initial        = "initial"
    case connecting     = "connecting"
    case connected      = "connected"
    case disconnected   = "disconnected"
}

public protocol QiscusRealtimeDelegate {
    func disconnect(withError err: Error?)
    func connected()
    func connectionState(change state: QiscusRealtimeConnectionState)
    
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
    ///   - data: message as string JSON
    func didReceiveMessage(data: String)
    
    
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
    func updateUser(typing: Bool, roomId: String, userEmail: String)
    
}
