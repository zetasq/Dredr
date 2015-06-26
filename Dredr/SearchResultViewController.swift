//
//  SearchResultViewController.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/26/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate
{
    
    var searchResults: [FeedlyResult] = []
    var dmBoard = DMBoard.sharedBoard
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nullBackgroundView: UIView!
    
    let CancelSearchIdentifier = "CancelFeedSearch"
    @IBAction func cancelSearch(sender: AnyObject) {
        performSegueWithIdentifier(CancelSearchIdentifier, sender: self)
    }
    
    let AddingSubscriptionIdentifier = "AddingChannelFinished"
    @IBAction func addSubscription(sender: AnyObject) {
        if let indices = (tableView.indexPathsForSelectedRows() ?? []) as? [NSIndexPath] {
            if indices.count > 0 {
                let selectedResults = indices.map { self.searchResults[$0.row] }
                for eachResult in selectedResults {
                    let channel = Channel(feedTitle: eachResult.feedTitle, feedUrl: eachResult.feedUrl)
                    dmBoard.currentAccount!.addChannel(channel)
                }
                performSegueWithIdentifier(AddingSubscriptionIdentifier, sender: self)
            } else {
                let alert = UIAlertController(title: "0 feeds selected", message: "You haven't select any feeds yet.", preferredStyle: .Alert)
                let confirmAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(confirmAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func config() {
        searchSpinner.hidden = true
        tableView.rowHeight = 50
    }
    
    func searchFeed(keyword: String) {
        var searchRequest = FeedlyRequest(searchTerm: keyword)
        
        searchSpinner.hidden = false
        searchSpinner.startAnimating()
        
        searchRequest.fetch {
            (results) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if let results = results {
                    if !results.isEmpty {
                        self.searchResults = results
                        self.tableView.reloadData()
                        self.nullBackgroundView.hidden = true
                    } else {
                        let alert = UIAlertController(title: "0 feeds found", message: "Try another keyword?", preferredStyle: .Alert)
                        let confirmAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(confirmAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Network Error", message: "No data received, please check your network settings.", preferredStyle: .Alert)
                    let confirmAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(confirmAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                self.searchSpinner.stopAnimating()
                self.searchSpinner.hidden = true
            }
        }
    }
    
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        config()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default) // make navigation bar totally translucent
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        searchBar.becomeFirstResponder()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    
    let CellReuseIdentifier = "SearchResultCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! SearchResultCell
        
        let searchResult = searchResults[indexPath.row]
        
        cell.searchResult = searchResult
        
        if dmBoard.currentAccount!.haveSubscribedToChannel(feedUrl: searchResults[indexPath.row].feedUrl) {
            cell.showCheckmark()
        } else {
            cell.hideCheckmark()
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SearchResultCell {
            cell.showCheckmark()
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SearchResultCell{
            cell.hideCheckmark()
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if dmBoard.currentAccount!.haveSubscribedToChannel(feedUrl: searchResults[indexPath.row].feedUrl) {
            
            let alert = UIAlertController(title: "Already Subscribed", message: "You have already subscribed to this feed", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(confirmAction)
            presentViewController(alert, animated: true, completion: nil)
            
            return nil
        } else {
            return indexPath
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    
    // MARK: UISearchBar delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if searchText != "" {
                searchFeed(searchText)
                searchBar.resignFirstResponder()
            }
        }
    }
}
