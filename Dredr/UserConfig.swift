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
    case SyncedWithiCloud = 1
}

final class UserConfig: NSObject, NSCoding
{
    static let defaultConfig = UserConfig(accountType: .Local, allowsBackgroundFetch: true)
    
    var accountType: AccountType = .Local
    
    var allowsBackgroundFetch = true
    
    init(accountType: AccountType, allowsBackgroundFetch: Bool) {
        self.accountType = accountType
        self.allowsBackgroundFetch = allowsBackgroundFetch
    }
    
    // MARK: NSCoding
    
    init(coder aDecoder: NSCoder) {
        super.init()
        
        accountType = AccountType(rawValue: aDecoder.decodeObjectForKey("accountType") as! Int) ?? .Local
        allowsBackgroundFetch = aDecoder.decodeObjectForKey("allowsBackgroundFetch") as! Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(accountType.rawValue, forKey: "accountType")
        aCoder.encodeObject(allowsBackgroundFetch, forKey: "allowsBackgroundFetch")
    }
}