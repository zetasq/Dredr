//
//  ArticleView.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/8/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class ArticleView: UIView {
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var titleAreaView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryAuthorLabel: UILabel!
    @IBOutlet weak var feedTitleLabel: UILabel!
    
    @IBOutlet weak var entryContentLabel: UILabel!
    
    weak var entry: Item! {
        didSet {
            if entry != nil {
                if entry.pubDate != nil {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "EEEE, MMM d, yyyy 'at' k:mm"
                    dateFormatter.locale = NSLocale.currentLocale()
                    timeLabel.text = dateFormatter.stringFromDate(entry.pubDate!)
                } else {
                    timeLabel.text = ""
                }
            }
            
            if entry.title != nil {
                entryTitleLabel.text = entry.title!
            } else {
                entryTitleLabel.text = ""
            }
            
            if entry.author != nil {
                entryAuthorLabel.text = entry.author!
            } else {
                entryAuthorLabel.text = ""
            }
            
            if entry.channel != nil {
                feedTitleLabel.text = entry.channel.feedTitle
            } else {
                feedTitleLabel.text = ""
            }
            
            if entry.content != nil { // if summary and content both exist, choose content first
                entryContentLabel.text = entry.content!
            } else {
                if entry.summary != nil { // in most circumstances an item has only summary
                    entryContentLabel.text = entry.summary!
                } else {
                    entryContentLabel.text = ""
                }
            }
        }
    }
    
    func loadNib() {
        NSBundle.mainBundle().loadNibNamed("ArticleView", owner: self, options: nil)
        
        addSubview(view)
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: .allZeros, metrics: nil, views: ["view": view]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: .allZeros, metrics: nil, views: ["view": view]))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadNib()
    }
}
