//
//  AccountCell.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/17/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
    
    @IBOutlet weak var accountLogoView: UIImageView!
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountSyncTimeLabel: UILabel!
    @IBOutlet weak var accountItemsCountLabel: UILabel!
    
    @IBOutlet weak var forwardView: UIImageView!
    
    var dmBoard = DMBoard.sharedBoard
    
    var account: Account! {
        didSet {
            if account != nil {
                updateUI()
                setSelected(selected, animated: false)
            }
        }
    }
    
    var itemCounter: Int {
        get {
            switch dmBoard.currentReadingScheme {
            case .All:
                return account.allItems.count
            case .Starred:
                return account.starredItems.count
            case .Unread:
                return account.unreadItems.count
            }
        }
        set {
            if newValue < 1000 {
                accountItemsCountLabel.text = "\(newValue)"
            } else {
                accountItemsCountLabel.text = "999+"
            }
        }
    }
    
    func updateUI() {
        accountNameLabel.text = account.userName
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yy, H:mm a"
        dateFormatter.locale = NSLocale.currentLocale()
        accountSyncTimeLabel.text = dateFormatter.stringFromDate(account.lastSync)
        
        switch dmBoard.currentReadingScheme {
        case .All:
            itemCounter = account.allItems.count
        case .Starred:
            itemCounter = account.starredItems.count
        case .Unread:
            itemCounter = account.unreadItems.count
        }
    }
    
    func highlightContent() {
        switch account.userConfig.accountType {
        case .Local:
            accountLogoView.image = UIImage(named: "rss_selected")
        case .SyncedWithiCloud:
            accountLogoView.image = UIImage(named: "cloud_selected")
        }
        
        accountSyncTimeLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        accountItemsCountLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        forwardView.image = UIImage(named: "forward_selected")
    }
    
    
    func resetContent() {
        switch account.userConfig.accountType {
        case .Local:
            accountLogoView.image = UIImage(named: "rss_unselected")
        case .SyncedWithiCloud:
            accountLogoView.image = UIImage(named: "cloud_unselected")
        }
        
        accountSyncTimeLabel.textColor = UIColor(red: 140.0/255, green: 140.0/255, blue: 140.0/255, alpha: 1.0)
        accountItemsCountLabel.textColor = UIColor(red: 140.0/255, green: 140.0/255, blue: 140.0/255, alpha: 1.0)
        forwardView.image = UIImage(named: "forward_unselected")
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if account != nil {
            if !selected {
                if highlighted {
                    highlightContent()
                } else {
                    resetContent()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if account != nil {
            if selected {
                highlightContent()
                backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
                //            println("selected: \(selected) highlighted: \(highlighted)")
            } else {
                resetContent()
                backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
                //            println("selected: \(selected) highlighted: \(highlighted)")
            }
        }
    }
}
