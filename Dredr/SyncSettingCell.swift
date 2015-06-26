//
//  SyncSettingCell.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/26/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class SyncSettingCell: UITableViewCell {

    @IBOutlet weak var syncSwitch: UISwitch!
    
    @IBAction func handleSwitch(sender: AnyObject) {
        account.userConfig.accountType = syncSwitch.on ? .SyncedWithiCloud : .Local
    }
    
    var account: Account! {
        didSet {
            if account != nil {
                syncSwitch.on = (account.userConfig.accountType == .SyncedWithiCloud)
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
