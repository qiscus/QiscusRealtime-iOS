//
//  chatRoomVC.swift
//  example
//
//  Created by asharijuang on 06/08/18.
//  Copyright © 2018 qiscus. All rights reserved.
//

import UIKit
import mqttLib
import SwiftyJSON

class QComment {
    var roomId:String = ""
    var commentId:Int = 0
    var text:String = ""
    var status: String = ""
    var uniqueId : String = ""
    var email: String = ""
    
}

class chatRoomVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var roomName: UILabel!
    var roomNameString = ""
    var mainApp = MainApp.shared
    var participantUser = "You, Crowdid92"
    var delegateRealtime    : QiscusRealtimeDelegate?
    var comment = [QComment]()
    var participantEmail = ["userid_332_628681011192@kiwari-prod.com"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roomName.text = roomNameString
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainApp.setupParticipantSubcribe(participantEmail: self.participantEmail)
        mainApp.qiscusRealtimeConnect(delegate: self)
    }
    
    func setupUI(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.register(ListChatCell.nib(), forCellReuseIdentifier: ListChatCell.identifier())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mainApp.unsubscribeRoomChannel()
    }

}

extension chatRoomVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (comment.count != 0){
            if let cell = tableView.dequeueReusableCell(withIdentifier: ListChatCell.identifier(), for: indexPath) as? ListChatCell{
                
                cell.commentLabel.text = comment[indexPath.row].text
                cell.statusLabel.text  = comment[indexPath.row].status
                return cell
            }
        }
        
        
        
        return UITableViewCell()
    }
}

extension chatRoomVC :UITableViewDelegate{
    
}

extension chatRoomVC : QiscusRealtimeDelegate {
    func didReceiveUserStatus(roomId: String, userEmail: String, timeString: String, timeToken: Double) {
        if(timeString != ""){
            self.subtitle.text = "Online"
        }else{
            self.subtitle.text = timeString
        }
    }
    
    func didReceiveMessageEvent(roomId: String, message: String) {
        let json = JSON(parseJSON:message)
        let payload = json["payload"]
        let data = payload["data"]
        let deleted_messages = data["deleted_messages"]
        let dataDeleteMessage = deleted_messages["message_unique_ids"]
         print("json 1 =\(dataDeleteMessage)")
        print("json ini =\(data)")
    }
    
    func didReceiveMessageComment(roomId: String, message: String) {
        let json = JSON(parseJSON:message)
        let roomId = "\(json["room_id"])"
        let commentId = json["id"].intValue
        let text      = json["message"].string ?? ""
        let uniqueId  = json["unique_temp_id"].string ?? ""
        let email     = json["email"].string ?? ""
        let comment = QComment()
        comment.commentId = commentId
        comment.roomId = roomId
        comment.status = ""
        comment.text = text
        comment.uniqueId = uniqueId
        comment.email   = email
         print("json ini =\(json)")
        self.comment.append(comment)
        self.tableView.reloadData()
    }
    
    func didReceiveMessageStatus(roomId: String, commentId: Int, Status: MessageStatus) {
        if(Status == .delivered){
            for item in comment.enumerated() {
                if(item.element.commentId == commentId && item.element.email == "userid_8898_628681011193@kiwari-prod.com"){
                    item.element.status = "delivered"
                }
            }
        }else{
            for item in comment.enumerated() {
                if(item.element.commentId == commentId && item.element.email == "userid_8898_628681011193@kiwari-prod.com"){
                    item.element.status = "read"
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    func updateUserTyping(roomId: String, userEmail: String) {
        if(userEmail != ""){
             self.subtitle.text = "Typing..."
        }else{
             self.subtitle.text = ""
        }
       
    }
    

}
