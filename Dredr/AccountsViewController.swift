//
//  AccountsViewController.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/27/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nullBackgroundView: UIView!
    
    @IBOutlet weak var unreadBarButton: UIBarButtonItem!
    @IBOutlet weak var allBarButton: UIBarButtonItem!
    @IBOutlet weak var starredBarButton: UIBarButtonItem!
    
    @IBAction func toggleUnread(sender: AnyObject) {
        if dmBoard.currentReadingScheme != .Unread {
            dmBoard.currentReadingScheme = .Unread
            loadTableView()
            configToolBar()
        }
    }
    
    @IBAction func toggleAll(sender: AnyObject) {
        if dmBoard.currentReadingScheme != .All {
            dmBoard.currentReadingScheme = .All
            loadTableView()
            configToolBar()
        }
    }
    
    @IBAction func toggleStarred(sender: AnyObject) {
        if dmBoard.currentReadingScheme != .Starred {
            dmBoard.currentReadingScheme = .Starred
            loadTableView()
            configToolBar()
        }
    }
    
    var refreshControl: UIRefreshControl!
    
    var dmBoard = DMBoard.sharedBoard
    
    func config() {
        initRefreshControl()
    }
    
    func configSelectedCell() {
        if let currentAccount = dmBoard.currentAccount {
            for (index, account) in enumerate(dmBoard.accounts) {
                if account == currentAccount {
                    tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: false, scrollPosition: .Middle)
                }
            }
        }
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
    
    func initRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.sendSubviewToBack(refreshControl)
    }
    
    func handleRefresh(sender: AnyObject) {
        // sync any cloud-supported account with iCloud
        tableView.layoutIfNeeded()
        refreshControl.endRefreshing()
    }
    
    func loadTableView() {
        nullBackgroundView.hidden = dmBoard.accounts.count > 0
        tableView.reloadData()
        configSelectedCell()
    }

    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadTableView()
        configToolBar()
        
        // these attributes should be reset in next viewcontroller's viewWillAppear() if default value is desired
        navigationController?.navigationBar.barStyle = .Black // used to set statusbar's color to white
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default) // used to make navigation bar totally translucent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dmBoard.accounts.count
    }

    let CellReuseIdentifier = "AccountCell"
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! AccountCell
        
        cell.account = dmBoard.accounts[indexPath.row]
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alert = UIAlertController(title: "Deleting Account", message: "All the subscriptions in this account will be lost", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
                (action) in
                self.tableView.editing = false
            }
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .Destructive) {
                (action) in
                self.dmBoard.removeAccountAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                // can't reloadData() here because it would block animation
                let timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "loadTableView", userInfo: nil, repeats: false)
            }

            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    

    // MARK: - Navigation

    let ShowAccountIdentifier = "ShowAccountDetail"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ShowAccountIdentifier {
            if let accountDetailVC = segue.destinationViewController as? AccountDetailViewController {
                dmBoard.currentAccount = dmBoard.accounts[tableView.indexPathForSelectedRow()!.row]
                dmBoard.currentChannel = nil
            }
        }
    }
    
    
    @IBAction
    func addAccount(segue: UIStoryboardSegue, sender: AnyObject?) {
        loadTableView()
    }
}
