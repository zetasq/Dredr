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

enum ReadingScheme: Printable {
    case All
    case Unread
    case Starred
    
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

enum HierarchyScheme {
    case SingleChannel
    case AllChannels
}

public class DMBoard
{
    static let sharedBoard = DMBoard()
    
    private init() {
        // import from core data
    }

    var accounts = [Account]()
    
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
    
}