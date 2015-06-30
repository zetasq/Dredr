//
//  DMBoard.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/25/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

/*

This singleton object is used as global data model for storing feed information, user preference and action parameter between controllers and views.

*/
import Foundation
import UIKit

enum ReadingScheme: Int, Printable {
    case All = 0
    case Unread = 1
    case Starred = 2
    
    var description: String {
        switch self {
        case .All:
            return "All"
        case .Starred:
            return "Starred"
        case .Unread:
            return "Unread"
        }
    }
}

enum HierarchyScheme: Int {
    case SingleChannel = 0
    case AllChannels = 1
}

public class DMBoard: NSObject, NSCoding
{
    static let sharedBoard = DMBoard()
    
    let AccountsDataFileName = "Accounts.data"
    let ModifyDateFileName = "ModifyDate.data"
    
    var accounts = [Account]()
    var modifyDate = NSDate()
    
    
    private override init() {
        super.init()
        
        let dataFilePath = getDocsDir().stringByAppendingPathComponent(AccountsDataFileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(dataFilePath) {
            if let storedAccounts = NSKeyedUnarchiver.unarchiveObjectWithFile(dataFilePath) as? [Account] {
                accounts = storedAccounts
            }
        }
        
        
        let modifyDateFilePath = getDocsDir().stringByAppendingPathComponent(ModifyDateFileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(modifyDateFilePath) {
            if let storedModifyDate = NSKeyedUnarchiver.unarchiveObjectWithFile(modifyDateFilePath) as? NSDate {
                modifyDate = storedModifyDate
            }
        }
    }
    
    func saveData() {
        let dataFilePath = getDocsDir().stringByAppendingPathComponent(AccountsDataFileName)
        NSKeyedArchiver.archiveRootObject(accounts, toFile: dataFilePath)
        
        
        let modifyDateFilePath = getDocsDir().stringByAppendingPathComponent(ModifyDateFileName)
        modifyDate = NSDate()
        NSKeyedArchiver.archiveRootObject(modifyDate, toFile: modifyDateFilePath)
    }
    
    func getDocsDir() -> String {
        let fileMgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as! String
        return docsDir
    }
    
    func refreshAccounts() {
        for account in accounts {
            if account.userConfig.allowsBackgroundFetch {
                for channel in account.channels {
                    channel.refreshContent()
                }
            }
        }
    }
    
    // MARK: State indicators
    
    var currentReadingScheme: ReadingScheme = .All // this determines the reading scheme in every viewcontroller that supports the switching between All, Unread and Starred. The viewcontroller should implement the toolbar and relevent switching functions.
    
    var currentHierarchyScheme: HierarchyScheme = .SingleChannel // this determines whether in AccountDetailController the user choose a singel channel or enter all channels by clicking cell named "All", "Starred" or "Unread". ChannelDetailViewController should act differently on this variable's possible values.
    
    var currentAccount: Account? // this variable should be set when an account is dived in, which is convenient for viewcontrollers to determine which account is currently on.
    
    var currentChannel: Channel? // this variable should be set when a channel is dived in, which is convenient for viewcontrollers to determine which channel is currently on.
    
    var currentItem: Item? // this variable should be set when an article(item) is dived in, which is used for further operations(add/remove tag)
    
    var refreshEveryFeed: Bool = true // this variable is used to determine whether the feeds should auto-refresh data when accountDetailVC reloads its tableView. If set to true, the feed will refresh anyway; if set to false, the feed only refreshs when its feedData is nil.
    
    
    func addAccount(userName: String, config: UserConfig) {
        let account = Account(userName: userName, userConfig: config)
        accounts.append(account)
    }
    
    func hasAccountNamed(name: String) -> Bool {
        for account in accounts {
            if account.userName == name {
                return true
            }
        }
        return false
    }
    
    func hasAccountNamed(name: String, except currentAccount: Account) -> Bool {
        for account in accounts {
            if account != currentAccount && account.userName == name {
                return true
            }
        }
        return false
    }
    
    func removeAccount(account: Account) -> Bool {
        if let index = find(accounts, account) {
            accounts.removeAtIndex(index)
            return true
        } else {
            return false
        }
    }
    
    func removeAccountAtIndex(index: Int) -> Bool {
        if index < accounts.count {
            accounts.removeAtIndex(index)
            return true
        } else {
            return false
        }
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init()
        
        accounts = aDecoder.decodeObjectForKey("accounts") as! [Account]
        currentReadingScheme = ReadingScheme(rawValue: aDecoder.decodeObjectForKey("currentReadingScheme") as! Int) ?? .All
        currentHierarchyScheme = HierarchyScheme(rawValue: aDecoder.decodeObjectForKey("currentHierarchyScheme") as! Int) ?? .SingleChannel
        currentAccount = aDecoder.decodeObjectForKey("currentAccount") as! Account?
        currentChannel = aDecoder.decodeObjectForKey("currentChannel") as! Channel?
        currentItem = aDecoder.decodeObjectForKey("currentItem") as! Item?
        refreshEveryFeed = aDecoder.decodeObjectForKey("refreshEveryFeed") as! Bool
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(accounts, forKey: "accounts")
        aCoder.encodeObject(currentReadingScheme.rawValue, forKey: "currentReadingScheme")
        aCoder.encodeObject(currentHierarchyScheme.rawValue, forKey: "currentHierarchyScheme")
        aCoder.encodeObject(currentAccount, forKey: "currentAccount")
        aCoder.encodeObject(currentChannel, forKey: "currentChannel")
        aCoder.encodeObject(currentItem, forKey: "currentItem")
        aCoder.encodeObject(refreshEveryFeed, forKey: "refreshEveryFeed")
    }
}