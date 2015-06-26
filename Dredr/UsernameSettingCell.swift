//
//  UsernameSettingCell.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/26/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class UsernameSettingCell: UITableViewCell {

    @IBOutlet weak var nameField: UITextField!
    
    var dmBoard = DMBoard.sharedBoard
    var account: Account! {
        didSet {
            if account != nil {
                nameField.text = account.userName
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

