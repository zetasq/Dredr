//
//  File.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/22/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation
import UIKit

public class Channel: NSObject, NSCoding, NSXMLParserDelegate {
    weak var account: Account?
    
    var feedTitle: String!
    var feedUrl: String!
    var favicon: UIImage?
    
    var feedData: FeedData?
    var lastSuccesfulRefresh: NSDate?
    private var isRefreshing = false // doesn't need to be encoded
    
    init(feedTitle: String, feedUrl: String) {
        super.init()
        self.feedTitle = feedTitle
        self.feedUrl = feedUrl
    }
    
    private func setItemsChannel() { // call this after refreshing data, let each item's channel point to self
        for eachItem in feedData!.items {
            eachItem.channel = self
        }
    }
    
    private var isLoadingFavicon = false // doesn't need to be encoded
    public func refreshFavicon() {
        if !isLoadingFavicon {
            isLoadingFavicon = true
            let faviconUrl = NSURL(scheme: "http", host: NSURL(string: feedUrl)!.host, path: "/favicon.ico")
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(faviconUrl!) {
                (data, response, error) -> Void in
                if error == nil {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            self.favicon = UIImage(data: data)
                        }
                    }
                }
                dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(DredrNotifications.FaviconRefreshingCompleted, object: self)
                }
                self.isLoadingFavicon = false
            }
            task.resume()
        }
    }
    
    private func updateOldData(newData: FeedData) {
        feedData = newData
        feedData?.sortItemsByDate()
        setItemsChannel()
        lastSuccesfulRefresh = NSDate()
        account?.dataUpdatedInChannel(self) // informs account that channel's items is updated
    }
    
    public func refreshContent() {
        if !isRefreshing {
            isRefreshing = true
            let url = NSURL(string: feedUrl!)
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
                (data, response, error) -> Void in
                if error == nil {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            
                            // check feed format (rss or atom)
                            let checkResult = FeedChecker.defaultChecker.checkFeedDataFormat(data)
                            var parser: Parser!
                            
                            if checkResult.feedFormat != .Unidentified {
                                
                                switch checkResult.feedFormat {
                                case .RSS:
                                    parser = RssParser(data: data)
                                case .Atom:
                                    parser = AtomParser(data: data)
                                default: break
                                }
                                
                                if self.feedData != nil {
                                    if checkResult.updatedDate != nil && self.feedData!.updatedDate != nil {
                                        if checkResult.updatedDate.compare(self.feedData!.updatedDate!) == .OrderedDescending {
                                            if let parsedData = parser.getParsedData() {
                                                self.updateOldData(parsedData)
                                            }
                                        }
                                    } else { // Caution: one of the updatedDate is nil, refresh anyway
                                        if let parsedData = parser.getParsedData() {
                                            self.updateOldData(parsedData)
                                        }
                                    }
                                } else { // this means the first refreshing
                                    if let parsedData = parser.getParsedData() {
                                        self.updateOldData(parsedData)
                                    }
                                }
                            }
                        }
                    }
                }
                dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(DredrNotifications.FeedDataRefreshingCompleted, object: self)
                }
                self.isRefreshing = false
            }
            task.resume()
        }
    }
    
    
    
    
    // MARK: - NSCoding methods
    required public init(coder aDecoder: NSCoder) {
        super.init()
        account = aDecoder.decodeObjectForKey("account") as! Account!
        
        feedTitle = aDecoder.decodeObjectForKey("feedTitle") as! String!
        feedUrl = aDecoder.decodeObjectForKey("feedUrl") as! String!
        favicon = aDecoder.decodeObjectForKey("favicon") as! UIImage?
        feedData = aDecoder.decodeObjectForKey("feedData") as! FeedData?
        lastSuccesfulRefresh = aDecoder.decodeObjectForKey("lastSuccessfulRefresh") as! NSDate?
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(account, forKey: "account")
        
        aCoder.encodeObject(feedTitle, forKey: "feedTitle")
        aCoder.encodeObject(feedUrl, forKey: "feedUrl")
        aCoder.encodeObject(favicon, forKey: "favicon")
        aCoder.encodeObject(feedData, forKey: "feedData")
        aCoder.encodeObject(lastSuccesfulRefresh, forKey: "lastSuccessfulRefresh")
    }
}

infix operator == { precedence 130 associativity none }
func ==(lhs: Channel, rhs: Channel) -> Bool {
    return lhs === rhs
}