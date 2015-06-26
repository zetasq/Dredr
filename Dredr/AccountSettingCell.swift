//
//  AccountSettingCell.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/26/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class AccountSettingCell: UITableViewCell {
    
    @IBOutlet weak var accountLogoView: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    
    var account: Account! {
        didSet {
            if account != nil {
                updateUI()
            }
        }
    }
    
    func updateUI() {
        switch account.userConfig.accountType {
        case .Local:
            accountLogoView.image = UIImage(named: "rss_unselected")
        case .SyncedWithiCloud:
            accountLogoView.image = UIImage(named: "cloud_unselected")
        }
        
        accountNameLabel.text = account.userName
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
