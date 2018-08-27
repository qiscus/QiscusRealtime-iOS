//
//  ViewController.swift
//  example
//
//  Created by asharijuang on 03/08/18.
//  Copyright © 2018 qiscus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var manager : RealtimeManager = RealtimeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.setup(appName: "Qiscus Chat")
        manager.connect(username: "amsibsan", password: "token")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



