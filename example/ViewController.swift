//
//  ViewController.swift
//  example
//
//  Created by asharijuang on 03/08/18.
//  Copyright © 2018 qiscus. All rights reserved.
//

import UIKit
import SwiftyJSON
import mqttLib


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var roomList: [String] = ["Arief","Juang", "room itu2"]
    var commentDummy: [String] = ["1","2","3"]
    var participantEmail = ["userid_332_628681011192@kiwari-prod.com"]
    var roomId = ["780816","796030",""]
    var mainApp = MainApp.shared
    var delegateRealtime    : QiscusRealtimeDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSub()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSub(){
        DispatchQueue.main.async {
            self.mainApp.setupRealtimeRoomPrivate(roomId: self.roomId)
        }
        
        mainApp.qiscusRealtimeConnect(delegate: self)
    }
    
    func setupUI(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.register(exampleCell.nib(), forCellReuseIdentifier: exampleCell.identifier())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainApp.qiscusRealtimeConnect(delegate: self)
    }
    
    
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = chatRoomVC()
        vc.roomNameString = roomList[indexPath.row]
        vc.delegateRealtime = self.delegateRealtime
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: exampleCell.identifier(), for: indexPath) as? exampleCell{
            
            cell.roomName.text      = roomList[indexPath.row]
            cell.lastMessage.text   = commentDummy[indexPath.row]
            cell.delegateCell       = self
            if(indexPath.row == 0){
                cell.roomId = "780816"
            }else {
                cell.roomId = ""
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension ViewController :UITableViewDelegate{
    
}

extension ViewController : QiscusRealtimeDelegate {
    func didReceiveUserStatus(roomId: String, userEmail: String, timeString: String, timeToken: Double) {
        
    }
    
    func didReceiveMessageStatus(roomId: String, commentId: Int, Status: MessageStatus) {
        
    }
    
    func didReceiveMessageEvent(roomId: String, message: String) {
        
    }
    
    func didReceiveMessageComment(roomId: String, message: String) {
        
    }
    
    func updateUserTyping(roomId: String, userEmail: String) {
        print("roomId =\(roomId) && userEmail = \(userEmail)")
    }
}



