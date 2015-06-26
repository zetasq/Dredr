//
//  FetchSettingCell.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/26/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class FetchSettingCell: UITableViewCell {

    @IBOutlet weak var fetchSwitch: UISwitch!
    
    var account: Account! {
        didSet {
            if account != nil {
                fetchSwitch.on = account.userConfig.allowsBackgroundFetch
            }
        }
    }
    
    @IBAction func handleSwitch(sender: AnyObject) {
        account.userConfig.allowsBackgroundFetch = fetchSwitch.on
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
