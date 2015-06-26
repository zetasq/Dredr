//
//  FeedlyResult.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/26/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation

public struct FeedlyResult
{
    let feedTitle: String
    let feedUrl: String
    
    init(feedTitle: String, feedUrl: String) {
        self.feedTitle = feedTitle
        self.feedUrl = feedUrl
    }
    
    init?(json: JSON) {
        let feedTitle = json["title"].string
        let feedId = json["feedId"].string
        if feedTitle != nil && feedId != nil {
            let feedUrl = feedId!.stringByReplacingOccurrencesOfString("feed/", withString: "", options: .LiteralSearch, range: feedId!.startIndex...advance(feedId!.startIndex, 5))
            
            self.feedTitle = feedTitle!
            self.feedUrl = feedUrl
        } else {
            return nil
        }
    }
}