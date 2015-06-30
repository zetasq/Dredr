//
//  ChannelViewController.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/23/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class ChannelDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var unreadBarButton: UIBarButtonItem!
    @IBOutlet weak var allBarButton: UIBarButtonItem!
    @IBOutlet weak var starredBarButton: UIBarButtonItem!
    
    var refreshControl: UIRefreshControl!
    
    var items: [Item] = []
    
    let dmBoard = DMBoard.sharedBoard
    var channel: Channel! // This channel equals dmBoard.currentChannel
    
    
    @IBAction func toggleUnread(sender: AnyObject) {
        if dmBoard.currentReadingScheme != .Unread {
            dmBoard.currentReadingScheme = .Unread
            configToolbar()
            configDataSource()
            configSelectedCell()
            configTitleLabel()
        }
    }
    
    @IBAction func toggleAll(sender: AnyObject) {
        if dmBoard.currentReadingScheme != .All {
            dmBoard.currentReadingScheme = .All
            configToolbar()
            configDataSource()
            configSelectedCell()
            configTitleLabel()
        }
    }
    
    @IBAction func toggleStarred(sender: AnyObject) {
        if dmBoard.currentReadingScheme != .Starred {
            dmBoard.currentReadingScheme = .Starred
            configToolbar()
            configDataSource()
            configSelectedCell()
            configTitleLabel()
        }
    }
    
    
    func handleRefresh(sender: AnyObject) {
        channel.refreshContent()
        tableView.layoutIfNeeded()
    }
    
    func initRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.sendSubviewToBack(refreshControl)
    }
    
    func channelRefreshed(notification: NSNotification) {
        dispatch_sync(dispatch_get_main_queue()) { () -> Void in
            self.configDataSource()
            self.refreshControl.endRefreshing()
        }
    }
    
    func config() {
        initRefreshControl()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func configTitleLabel() {
        switch dmBoard.currentHierarchyScheme {
        case .AllChannels:
            feedTitleLabel.text = "\(dmBoard.currentReadingScheme)"
        case .SingleChannel:
            feedTitleLabel.text = channel.feedTitle
        }
    }
    
    func configToolbar() {
        for barButton in [unreadBarButton, allBarButton, starredBarButton] {
            barButton.tintColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        }
        
        switch dmBoard.currentReadingScheme {
        case .All:
            allBarButton.tintColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        case .Starred:
            starredBarButton.tintColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        case .Unread:
            unreadBarButton.tintColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        }
    }
    
    func configDataSource() {
        switch dmBoard.currentHierarchyScheme {
        case .AllChannels:
            switch dmBoard.currentReadingScheme {
            case .All:
                items = dmBoard.currentAccount!.allItems
            case .Unread:
                items = dmBoard.currentAccount!.unreadItems
            case .Starred:
                items = dmBoard.currentAccount!.starredItems
            }
        case .SingleChannel:
            switch dmBoard.currentReadingScheme {
            case .All:
                items = dmBoard.currentAccount!.allItems.filter { $0.channel == self.channel }
            case .Unread:
                items = dmBoard.currentAccount!.unreadItems.filter { $0.channel == self.channel }
            case .Starred:
                items = dmBoard.currentAccount!.starredItems.filter { $0.channel == self.channel }
            }
        }
        
        tableView.reloadData()
    }
    
    func configSelectedCell() {
        if let currentItem = dmBoard.currentItem {
            for (index, item) in enumerate(items) {
                if item == currentItem {
                    tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: false, scrollPosition: .Middle)
                    break
                }
            }
        }
    }
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "channelRefreshed:", name: DredrNotifications.FeedDataRefreshingCompleted, object: channel)
        
        configDataSource()
        configSelectedCell()
        configToolbar()
        configTitleLabel()
 
        navigationController?.navigationBar.shadowImage = nil // shadow for navigationbar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default) // set navigationbar totally translucent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    let CellReuseIdentifer = "ItemCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifer, forIndexPath: indexPath) as! ItemCell
        
        cell.entry = items[indexPath.row]
        
        return cell
    }
    
    // MARK: - Navigation
    let ShowItemDetailIdentifier = "ShowItemDetail"
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ShowItemDetailIdentifier {
            if let itemDetailVC = segue.destinationViewController as? ItemDetailViewController {
                itemDetailVC.entries = items
                itemDetailVC.currentIndex = tableView.indexPathForSelectedRow()!.row
            }
        }
    }

}
