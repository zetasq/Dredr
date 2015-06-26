//
//  FeedData.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/2/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation
import UIKit

class FeedData: NSObject, NSCoding {
    var lastBuildDate: NSDate? // this field is only for RSS
    var pubDate: NSDate? // this field is for RSS and Atom
    var siteName: String?
    var siteUrl: String?
    var siteDescription: String?
    
    var items: [Item] = []
    
    var updatedDate: NSDate? {
        switch (lastBuildDate, pubDate) {
        case (nil, nil): return nil
        case (_, nil): return lastBuildDate
        case (nil, _): return pubDate
        case (_, _): return lastBuildDate
        }
    }
    
    override init() {
        super.init()
    }
    
    func sortItemsByDate() {
        items.sort {
            if $0.pubDate == nil {
                return false
            } else if $1.pubDate == nil {
                return true
            } else {
                return $0.pubDate!.compare($1.pubDate!) == .OrderedDescending
            }
        }
    }
    
    func getUnread() -> [Item] {
        return items.filter { $0.isRead == false }
    }
    
    func getStarred() -> [Item] {
        return items.filter { $0.isStarred == true }
    }
    
    // MARK: - NSCoding methods
    required init(coder aDecoder: NSCoder) {
        super.init()
        lastBuildDate = aDecoder.decodeObjectForKey("lastBuildDate") as! NSDate?
        pubDate = aDecoder.decodeObjectForKey("pubDate") as! NSDate?
        siteName = aDecoder.decodeObjectForKey("siteName") as! String?
        siteUrl = aDecoder.decodeObjectForKey("siteUrl") as! String?
        siteDescription = aDecoder.decodeObjectForKey("siteDescription") as! String?
        items = aDecoder.decodeObjectForKey("items") as! [Item]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(lastBuildDate, forKey: "lastBuildDate")
        aCoder.encodeObject(pubDate, forKey: "pubDate")
        aCoder.encodeObject(siteName, forKey: "siteName")
        aCoder.encodeObject(siteUrl, forKey: "siteUrl")
        aCoder.encodeObject(siteDescription, forKey: "siteDescription")
        aCoder.encodeObject(items, forKey: "items")
    }
    
}

infix operator == { precedence 130 associativity none }
func ==(lhs: FeedData, rhs: FeedData) -> Bool {
    return lhs === rhs
}