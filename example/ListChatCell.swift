//
//  ListChatCell.swift
//  example
//
//  Created by asharijuang on 07/08/18.
//  Copyright © 2018 qiscus. All rights reserved.
//

import UIKit

class ListChatCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
