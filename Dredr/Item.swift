//
//  File.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/22/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation

final class Item: NSObject, NSCoding, Equatable {
    weak var channel: Channel!
    
    var title: String?
    var author: String?
    var link: String?
    var summary: String?
    var content: String?
    var pubDate: NSDate?
    
    var isRead = false
    var isStarred = false
    
    override init() {
        super.init()
    }
    
    
    // MARK: - NSCoding methods
    init(coder aDecoder: NSCoder) {
        super.init()
        channel = aDecoder.decodeObjectForKey("channel") as! Channel!
        title = aDecoder.decodeObjectForKey("title") as! String?
        author = aDecoder.decodeObjectForKey("author") as! String?
        link = aDecoder.decodeObjectForKey("link") as! String?
        summary = aDecoder.decodeObjectForKey("summary") as! String?
        content = aDecoder.decodeObjectForKey("content") as! String?
        pubDate = aDecoder.decodeObjectForKey("pubDate") as! NSDate?
        isRead = aDecoder.decodeObjectForKey("isRead") as! Bool
        isStarred = aDecoder.decodeObjectForKey("isStarred") as! Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(channel, forKey: "channel")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(author, forKey: "author")
        aCoder.encodeObject(link, forKey: "link")
        aCoder.encodeObject(summary, forKey: "summary")
        aCoder.encodeObject(content, forKey: "content")
        aCoder.encodeObject(pubDate, forKey: "pubDate")
        aCoder.encodeObject(isRead, forKey: "isRead")
        aCoder.encodeObject(isStarred, forKey: "isStarred")
    }
}

// MARK: - Equatable
infix operator == { precedence 130 associativity none }
func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs === rhs
}
