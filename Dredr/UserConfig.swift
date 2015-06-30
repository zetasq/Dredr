//
//  UserConfig.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/27/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation

enum AccountType: Int {
    case Local = 0
    case SyncedWithiCloud = 1 // iCloud syncing is too complicated, this case is neverused. (Maybe in the future support syncing with feed site like feedly)
}

let storagePickerTitles = ["Forever", "One day", "One week", "One month"]
let storageDaysSource = [0, 1, 7, 30]

final class UserConfig: NSObject, NSCoding
{
    static let defaultConfig = UserConfig(accountType: .Local, allowsBackgroundFetch: true, storageDays: 0)
    
    var accountType: AccountType = .Local
    var allowsBackgroundFetch = true
    var storageDays = 0 // 0 means forever, 1 means keep items for one day when refreshed, 7 means a week
    
    init(accountType: AccountType, allowsBackgroundFetch: Bool, storageDays: Int) {
        self.accountType = accountType
        self.allowsBackgroundFetch = allowsBackgroundFetch
        self.storageDays = storageDays
    }
    
    // MARK: NSCoding
    
    init(coder aDecoder: NSCoder) {
        super.init()
        
        accountType = AccountType(rawValue: aDecoder.decodeObjectForKey("accountType") as! Int) ?? .Local
        allowsBackgroundFetch = aDecoder.decodeObjectForKey("allowsBackgroundFetch") as! Bool
        storageDays = aDecoder.decodeObjectForKey("storageDays") as! Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(accountType.rawValue, forKey: "accountType")
        aCoder.encodeObject(allowsBackgroundFetch, forKey: "allowsBackgroundFetch")
        aCoder.encodeObject(storageDays, forKey: "storageDays")
    }
}