//
//  Account.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/25/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation

final class Account: NSObject, NSCoding, Equatable
{
    var userName: String = "noName"
    var userConfig: UserConfig = UserConfig.defaultConfig
    var lastSync: NSDate = NSDate()
    
    init(userName: String, userConfig: UserConfig) {
        self.userName = userName
        self.userConfig = userConfig
        self.lastSync = NSDate()
    }
    
    var channels = [Channel]()

    var allItems = [Item]()
    var unreadItems = [Item]()
    var starredItems = [Item]()
    
    func makeItemRead(item: Item) -> Bool {
        item.isRead = true
        
        if let index = find(unreadItems, item) {
            unreadItems.removeAtIndex(index)
            return true
        } else {
            return false
        }
    }
    
    
    func makeItemUnread(item: Item) -> Bool {
        item.isRead = false
        
        if contains(unreadItems, item) {
            return false
        }
        
        unreadItems.append(item)
        return true
    }
    
    
    func makeItemStarred(item: Item) -> Bool {
        item.isStarred = true
        
        if !contains(starredItems, item) {
            starredItems.append(item)
            return true
        } else {
            return false
        }
    }
    
    func makeItemUnstarred(item: Item) -> Bool {
        item.isStarred = false
        
        if let index = find(starredItems, item) {
            starredItems.removeAtIndex(index)
            return true
        } else {
            return false
        }
    }
    
    func addChannel(channel: Channel) -> Bool {
        channel.account = self
        if !contains(channels, channel) {
            channels.append(channel)
            return true
        } else {
            return false
        }
    }
    
    func removeChannel(channel: Channel) -> Bool {
        if contains(channels, channel) {
            channels = channels.filter { $0 != channel }
            allItems = allItems.filter { $0.channel != channel }
            unreadItems = unreadItems.filter { $0.channel != channel }
            starredItems = starredItems.filter { $0.channel != channel }
            return true
        } else {
            return false
        }
    }
    
    func haveSubscribedToChannel(#feedUrl: String) -> Bool {
        for eachChannel in channels {
            if eachChannel.feedUrl == feedUrl {
                return true
            }
        }
        return false
    }
    
    func dataUpdatedInChannel(channel: Channel) {
        // remove old items of channel
        allItems = allItems.filter { $0.channel != channel }
        unreadItems = unreadItems.filter { $0.channel != channel }
        starredItems = starredItems.filter { $0.channel != channel }
        
        allItems += channel.feedData!.items
        unreadItems += channel.feedData!.items
    }
    
    
    // MARK: - NSCoding
    init(coder aDecoder: NSCoder) {
        super.init()
        
        userName = aDecoder.decodeObjectForKey("userName") as! String
        userConfig = aDecoder.decodeObjectForKey("userConfig") as! UserConfig
        lastSync = aDecoder.decodeObjectForKey("lastSync") as! NSDate
        
        channels = aDecoder.decodeObjectForKey("channels") as! [Channel]
        allItems = aDecoder.decodeObjectForKey("allItems") as! [Item]
        unreadItems = aDecoder.decodeObjectForKey("unreadItems") as! [Item]
        starredItems = aDecoder.decodeObjectForKey("starredItems") as! [Item]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(userName, forKey: "userName")
        aCoder.encodeObject(userConfig, forKey: "userConfig")
        aCoder.encodeObject(lastSync, forKey: "lastSync")
        
        aCoder.encodeObject(channels, forKey: "channels")
        aCoder.encodeObject(allItems, forKey: "allItems")
        aCoder.encodeObject(unreadItems, forKey: "unreadItems")
        aCoder.encodeObject(starredItems, forKey: "starredItems")
    }
}

// MARK: - Equatable
infix operator == { precedence 130 associativity none }
func ==(lhs: Account, rhs: Account) -> Bool {
    return lhs === rhs
}

