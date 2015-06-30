//
//  AccountDetailViewController.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/27/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class AccountDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var unreadBarButton: UIBarButtonItem!
    @IBOutlet weak var allBarButton: UIBarButtonItem!
    @IBOutlet weak var starredBarButton: UIBarButtonItem!
    
    
    
    var selectedPath: NSIndexPath?
    var refreshControl: UIRefreshControl!
    
    var dmBoard = DMBoard.sharedBoard
    
    @IBAction func toggleUnread(sender: AnyObject) {
        if dmBoard.currentReadingScheme != .Unread {
            dmBoard.currentReadingScheme = .Unread
            configToolBar()
            loadWithoutAutoRefresh()
            configSelectedCell()
        }
    }
    
    @IBAction func toggleAll(sender: AnyObject) {
        if dmBoard.currentReadingScheme != .All {
            dmBoard.currentReadingScheme = .All
            configToolBar()
            loadWithoutAutoRefresh()
            configSelectedCell()
        }
    }
    
    @IBAction func toggleStarred(sender: AnyObject) {
        if dmBoard.currentReadingScheme != .Starred {
            dmBoard.currentReadingScheme = .Starred
            configToolBar()
            loadWithoutAutoRefresh()
            configSelectedCell()
        }
    }
    
    func handleRefresh(sender: AnyObject) {
        loadWithAutoRefresh()
        tableView.layoutIfNeeded()
        refreshControl.endRefreshing()
    }
    
    func initRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.sendSubviewToBack(refreshControl)
    }
    
    func config() {
        initRefreshControl()
        
        dmBoard.refreshEveryFeed = false
        
        accountNameLabel.text = dmBoard.currentAccount!.userName
        tableView.rowHeight = 50
    }
    
    func configToolBar() {
        for button in [unreadBarButton, allBarButton, starredBarButton] {
            button.tintColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
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
    
    func loadWithoutAutoRefresh() {
        dmBoard.refreshEveryFeed = false
        tableView.reloadData()
    }
    
    func loadWithAutoRefresh() {
        dmBoard.refreshEveryFeed = true
        tableView.reloadData()
    }
    
    func configSelectedCell() {
        if let currentChannel = dmBoard.currentChannel {
            for (index, channel) in enumerate(dmBoard.currentAccount!.channels) {
                if currentChannel == channel {
                    tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1), animated: false, scrollPosition: .Middle)
                }
            }
        }
        
        // TODO: handle Unread ans starred session
    }
    
    func handleChannelRefreshed(notification: NSNotification) {
        dispatch_sync(dispatch_get_main_queue()) { () -> Void in
            if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? AllChannelsCell {
                cell.updateUI()
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
        
        loadWithoutAutoRefresh()
        configSelectedCell()
        configToolBar()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleChannelRefreshed:", name: DredrNotifications.FeedDataRefreshingCompleted, object: nil)
        
        // these attributes should be reset in neighbour's viewWillAppear() if default behavior is desired
        navigationController?.navigationBar.barStyle = .Default // black status bar
        navigationController?.navigationBar.shadowImage = nil // shadow for navigationbar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default) // make navigationbar totally translucent
        navigationController?.navigationBar.tintColor = UIColor(red: 128.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0) // tint the back arrow
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return dmBoard.currentAccount!.channels.count
        }
    }

    
    let AllChannelsCellIdentifier = "AllChannelsCell"
    let ChannelCellIdentifier = "ChannelCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(AllChannelsCellIdentifier, forIndexPath: indexPath) as! AllChannelsCell
            
            cell.updateUI()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(ChannelCellIdentifier, forIndexPath: indexPath) as! ChannelCell
            
            let channel = dmBoard.currentAccount!.channels[indexPath.row]
            cell.channel = channel
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ChannelCell{
            if cell.isLoading || cell.channel!.feedData == nil {
                return nil
            }
        }
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            dmBoard.currentHierarchyScheme = .AllChannels
        } else {
            dmBoard.currentHierarchyScheme = .SingleChannel
        }
        
        dmBoard.currentItem = nil
        performSegueWithIdentifier(ShowChannelDetailIdentifier, sender: self)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alert = UIAlertController(title: "Unsubscribing Feed", message: "You will no longer receive articles from this feed.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
                (action) -> Void in
                tableView.editing = false
            }
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .Destructive) {
                (action) -> Void in
                self.dmBoard.currentAccount!.removeChannel(self.dmBoard.currentAccount!.channels[indexPath.row])
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .None)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    
    // MARK: - Navigation

    let ShowChannelDetailIdentifier = "ShowChannelDetail"
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ShowChannelDetailIdentifier {
            if let channelDetailVC = segue.destinationViewController as? ChannelDetailViewController {
                switch dmBoard.currentHierarchyScheme {
                case .AllChannels:
                    break
                case .SingleChannel:
                    channelDetailVC.channel = dmBoard.currentAccount!.channels[tableView.indexPathForSelectedRow()!.row]
                    dmBoard.currentChannel = channelDetailVC.channel // set currentChannel for keeping row selection
                }
            }
        }
    }
    
    @IBAction
    func addingChannelFinished(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let addChannelVC = segue.sourceViewController as? SearchResultViewController {
            loadWithoutAutoRefresh() // this will refresh those feeds whose feedData is nil (which means they are just added)
        }
    }
    
    @IBAction
    func cancelFeedSearch(segue: UIStoryboardSegue, sender: AnyObject?) {}
}
