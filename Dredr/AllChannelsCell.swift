//
//  AllChannelsCell.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/24/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class AllChannelsCell: UITableViewCell {

    @IBOutlet weak var faviconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    
    var dmBoard = DMBoard.sharedBoard
    
    var itemCounter: Int {
        get {
            switch dmBoard.currentReadingScheme {
            case .All:
                return dmBoard.currentAccount!.allItems.count
            case .Starred:
                return dmBoard.currentAccount!.starredItems.count
            case .Unread:
                return dmBoard.currentAccount!.unreadItems.count
            }
        }
        set {
            if newValue < 1000 {
                itemCountLabel.text = "\(newValue)"
            } else {
                itemCountLabel.text = "999+"
            }
        }
    }
    
    func updateUI() {
        switch dmBoard.currentReadingScheme {
        case .All:
            faviconView.image = UIImage(named: "all")
            itemCounter = dmBoard.currentAccount!.allItems.count
        case .Starred:
            faviconView.image = UIImage(named: "starred")
            itemCounter = dmBoard.currentAccount!.starredItems.count
        case .Unread:
            faviconView.image = UIImage(named: "unread")
            itemCounter = dmBoard.currentAccount!.unreadItems.count
        }
        
        titleLabel.text = "\(dmBoard.currentReadingScheme)"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        } else {
            backgroundColor = UIColor(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
