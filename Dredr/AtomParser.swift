//
//  AtomParser.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/23/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation

final class AtomParser: NSObject, Parser
{
    var data: NSData
    var xmlParser: NSXMLParser?
    var parseStack = [String]()
    var tempItem: Item?
    var currentContent: String?
    
    var feedData: FeedData?
    
    init(data: NSData) {
        self.data = data
    }
    
    func getParsedData() -> FeedData? {
        feedData = FeedData()
        xmlParser = NSXMLParser(data: data)
        xmlParser!.delegate = self
        if xmlParser!.parse() == true {
            return feedData
        } else {
            return nil
        }
    }
    
    // MARK: NSXMLParser delegate
    func parserDidStartDocument(parser: NSXMLParser) {
        parseStack = []
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        currentContent = ""
        
        switch elementName {
        case "feed":
            parseStack.append(elementName)
        case "entry":
            parseStack.append(elementName)
            tempItem = Item()
        case "title":
            parseStack.append(elementName)
        case "updated":
            parseStack.append(elementName)
        case "link":
            if !parseStack.isEmpty {
                switch parseStack.last! {
                case "feed":
                    feedData!.siteUrl = attributeDict["href"] as? String
                case "entry":
                    tempItem!.link = attributeDict["href"] as? String
                default: break
                }
            }
            parseStack.append(elementName)
        case "author":
            parseStack.append(elementName)
        case "name":
            parseStack.append(elementName)
        case "summary":
            parseStack.append(elementName)
        case "content":
            parseStack.append(elementName)
        default: break
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "feed":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
        case "entry":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            feedData!.items.append(tempItem!)
        case "title":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            if !parseStack.isEmpty {
                switch parseStack.last! {
                case "feed":
                    feedData!.siteName = currentContent!.html2String
                case "entry":
                    tempItem?.title = currentContent!.html2String
                default: break
                }
            }
        case "updated":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            if !parseStack.isEmpty {
                switch parseStack.last! {
                case "feed":
                    feedData!.pubDate = AtomParser.dateFromPubDate(currentContent!)
                case "entry":
                    tempItem?.pubDate = AtomParser.dateFromPubDate(currentContent!)
                default: break
                }
            }
        case "link":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            if !parseStack.isEmpty {
                switch parseStack.last! {
                case "feed":
                    feedData!.siteUrl = currentContent!
                case "entry":
                    tempItem?.link = currentContent!
                default: break
                }
            }
            
        case "author":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
        case "name":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            if parseStack.count > 1 {
                switch parseStack[parseStack.count-2] {
                case "entry":
                    tempItem?.author = currentContent!.html2String
                default: break
                }
            }
        case "summary":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            if !parseStack.isEmpty {
                switch parseStack.last! {
                case "entry":
                    tempItem?.summary = currentContent!.html2String
                default: break
                }
            }
        case "content":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            if !parseStack.isEmpty {
                switch parseStack.last! {
                case "entry":
                    tempItem?.content = currentContent!.html2String
                default: break
                }
            }
        default: break
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        currentContent! += string!
    }
    
    
    func parserDidEndDocument(parser: NSXMLParser) {
        parseStack = []
        tempItem = nil
        currentContent = nil
    }
    
    static func dateFromPubDate(date: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        for format in RFC3339 {
            dateFormatter.dateFormat = format
            if let parsedDate = dateFormatter.dateFromString(date) {
                return parsedDate
            }
        }
        return nil
    }
    
    
}