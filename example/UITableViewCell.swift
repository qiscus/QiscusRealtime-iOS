//
//  UITableViewCell.swift
//  CustomChat
//
//  Created by QiscusiOS on 22/01/18.
//  Copyright © 2018 QiscusiOS. All rights reserved.
//


import UIKit

extension UITableViewCell {
    static func identifier()->String{
        return String(describing: self)
    }
    static func nib()->UINib{
        return UINib(nibName: identifier(), bundle: nil)
    }
}
