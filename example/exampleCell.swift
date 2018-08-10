//
//  exampleCell.swift
//  example
//
//  Created by asharijuang on 06/08/18.
//  Copyright © 2018 qiscus. All rights reserved.
//

import UIKit
import QiscusRealtime

class exampleCell: UITableViewCell{
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    var roomId = ""
    var delegateCell : QiscusRealtimeDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codes
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



