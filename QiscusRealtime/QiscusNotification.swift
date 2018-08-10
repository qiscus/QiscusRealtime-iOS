//
//  QiscusNotification.swift
//  Example
//
//  Created by Ahmad Athaullah on 9/12/17.
//  Copyright © 2017 Ahmad Athaullah. All rights reserved.
//

import UIKit

public class QiscusNotification: NSObject {
    
    static let shared = QiscusNotification()
    let nc = NotificationCenter.default
    var roomOrderTimer:Timer?
    
    private static var typingTimer = [String:Timer]()
    
    public static let MESSAGE_STATUS = NSNotification.Name("qiscus_messageStatus")
    public static let USER_PRESENCE = NSNotification.Name("quscys_userPresence")
    public static let USER_AVATAR_CHANGE = NSNotification.Name("qiscus_userAvatarChange")
    public static let USER_NAME_CHANGE = NSNotification.Name("qiscus_userNameChange")
    public static let GOT_NEW_ROOM = NSNotification.Name("qiscus_gotNewRoom")
    public static let GOT_NEW_COMMENT = NSNotification.Name("qiscus_gotNewComment")
    public static let ROOM_DELETED = NSNotification.Name("qiscus_roomDeleted")
    public static let ROOM_ORDER_MAY_CHANGE = NSNotification.Name("qiscus_romOrderChange")
    public static let FINISHED_CLEAR_MESSAGES = NSNotification.Name("qiscus_finishedClearMessages")
    public static let FINISHED_SYNC_ROOMLIST = NSNotification.Name("qiscus_finishedSyncRoomList")
    public static let START_CLOUD_SYNC = NSNotification.Name("qiscus_startCloudSync")
    public static let FINISHED_CLOUD_SYNC = NSNotification.Name("qiscus_finishedCloudSync")
    public static let ERROR_CLOUD_SYNC = NSNotification.Name("qiscus_finishedCloudSync")
    
    override private init(){
        super.init()
    }
    // MARK: Notification Name With Specific Data
    public class func USER_TYPING(onRoom roomId: String) -> NSNotification.Name {
        return NSNotification.Name("qiscus_userTyping_\(roomId)")
    }
    public class func ROOM_CHANGE(onRoom roomId: String) -> NSNotification.Name {
        return NSNotification.Name("qiscus_roomChange_\(roomId)")
    }
    public class func ROOM_CLEARMESSAGES(onRoom roomId: String) -> NSNotification.Name {
        return NSNotification.Name("qiscus_clearMessages_\(roomId)")
    }
    public class func COMMENT_DELETE(onRoom roomId: String) -> NSNotification.Name {
        return NSNotification.Name("qiscus_commentDelete_\(roomId)")
    }
    
    public class func publish(userTyping userEmail:String, roomId:String ,typing:Bool = true){
        let notification = QiscusNotification.shared
        notification.publish(userTyping: userEmail, roomId: roomId, typing: typing)
    }
    
    
    private func publish(userTyping userEmail:String, roomId:String ,typing:Bool = true){
        
        let userInfo: [AnyHashable: Any] = ["room" : roomId, "userEmail" : userEmail, "typing": typing]
        
        self.nc.post(name: QiscusNotification.USER_TYPING(onRoom: roomId), object: nil, userInfo: userInfo)
        
        if typing {
            if QiscusNotification.typingTimer[roomId] != nil {
                QiscusNotification.typingTimer[roomId]!.invalidate()
            }
            QiscusNotification.typingTimer[roomId] = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(QiscusNotification.clearUserTyping(timer:)), userInfo: userInfo, repeats: false)
        }else{
            if QiscusNotification.typingTimer[roomId] != nil {
                QiscusNotification.typingTimer[roomId]!.invalidate()
                QiscusNotification.typingTimer[roomId] = nil
            }
        }
    }
    @objc private func clearUserTyping(timer: Timer){
        let data = timer.userInfo as! [AnyHashable : Any]
        let userEmail = data["userEmail"] as! String
        let roomId = data["room"] as! String
        
        self.publish(userTyping: userEmail, roomId: roomId, typing: false)
    }
    
    
}

