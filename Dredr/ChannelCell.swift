//
//  ChannelCell.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/3/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    @IBOutlet weak var faviconImageView: UIImageView!
    @IBOutlet weak var siteNameLabel: UILabel!
    @IBOutlet weak var itemCounterLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var forwardView: UIImageView!
    
    let dmBoard = DMBoard.sharedBoard
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var channel: Channel! {
        didSet {
            if channel != nil {
                NSNotificationCenter.defaultCenter().removeObserver(self) // incase this cell has been reused
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "channelRefreshed:", name: DredrNotifications.FeedDataRefreshingCompleted, object: channel)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "faviconRefreshed:", name: DredrNotifications.FaviconRefreshingCompleted, object: channel)
                
                if dmBoard.refreshEveryFeed || channel.feedData == nil {
                    updateWithRefresh()
                } else {
                    updateUI()
                }
            }
        }
    }
    
    var itemCounter: Int {
        get {
            return channel.feedData!.items.count
        }
        set {
            if newValue < 1000 {
                itemCounterLabel.text = "\(newValue)"
            } else {
                itemCounterLabel.text = "999+"
            }
        }
    }
    
    var isLoading = false
    
    func updateItemCounter() {
        switch dmBoard.currentReadingScheme {
        case .All:
            itemCounter = channel.feedData!.items.count
        case .Starred:
            itemCounter = channel.feedData!.getStarred().count
        case .Unread:
            itemCounter = channel.feedData!.getUnread().count
        }
    }
    
    func updateUI() {
        if !isLoading {
            isLoading = true
            
            siteNameLabel.text = channel.feedTitle
            spinner.hidden = true
            warningLabel.hidden = true
            forwardView.hidden = false
            
            if channel.favicon != nil {
                faviconImageView.image = channel.favicon!
            }
            
            updateItemCounter()
            
            isLoading = false
        }
    }
    
    func updateWithRefresh() {
        if !isLoading {
            isLoading = true
            siteNameLabel.text = channel.feedTitle
            itemCounterLabel.text = ""
            warningLabel.hidden = true
            forwardView.hidden = true
            spinner.hidden = false
            spinner.startAnimating()
            
            
            // fetch feedData
            channel.refreshContent()
            
            // fetch favicon
            if channel.favicon != nil {
                faviconImageView.image = channel.favicon!
            }
            channel.refreshFavicon()
        }
    }
    
    func channelRefreshed(notification: NSNotification) {
        if channel.feedData != nil {
            updateItemCounter()
            forwardView.hidden = false
        } else {
            self.warningLabel.hidden = false
        }
        
        spinner.stopAnimating()
        spinner.hidden = true
        isLoading = false
    }
    
    func faviconRefreshed(notification: NSNotification) {
        if channel.favicon != nil {
            faviconImageView.image = channel.favicon!
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
