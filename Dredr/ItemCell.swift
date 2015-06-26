//
//  ItemCell.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/23/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var faviconView: UIImageView!
    
    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var forwardView: UIImageView!
    
    var entry: Item! {
        didSet {
            if entry != nil {
                updateUI()
            }
        }
    }
    
    func updateUI() {
        if entry.channel != nil {
            feedTitleLabel.text = entry.channel.feedTitle
            if let image = entry.channel.favicon {
                faviconView.image = image
            }
        } else {
            feedTitleLabel.text = ""
        }
        
        if entry.title != nil {
            titleLabel.text = entry.title!
        } else {
            titleLabel.text = ""
        }
        
        if entry.pubDate != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "k:m"
            dateFormatter.locale = NSLocale.currentLocale()
            updateTimeLabel.text = dateFormatter.stringFromDate(entry.pubDate!)
        } else {
            updateTimeLabel.text = ""
        }
        
        if entry.summary != nil {
            summaryLabel.text = entry.summary!
        } else {
            if entry.content != nil {
                summaryLabel.text = entry.content!
            } else {
                summaryLabel.text = ""
            }
        }
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
