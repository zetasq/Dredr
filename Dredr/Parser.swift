//
//  AbstractParser.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/23/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation

protocol Parser: NSXMLParserDelegate
{
    var data: NSData { get set } // raw data 
    var xmlParser: NSXMLParser? { get }
    var parseStack: [String] { get }
    var tempItem: Item? { get }
    var currentContent: String? { get }
    
    var feedData: FeedData? { get }
    
    init(data: NSData)

    func getParsedData() -> FeedData? // return feedData
}