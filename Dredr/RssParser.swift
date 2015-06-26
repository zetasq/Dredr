//
//  RssParser.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/23/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation

final class RssParser: NSObject, Parser
{
    var data: NSData
    var xmlParser: NSXMLParser?
    var parseStack = [String]()
    var tempItem: Item?
    var currentContent: String?
    
    var feedData: FeedData?
    
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
    
    init(data: NSData) {
        self.data = data
    }
    
    // MARK: NSXMLParser delegate
    func parserDidStartDocument(parser: NSXMLParser) {
        parseStack = []

    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        currentContent = ""
        switch elementName {
        case "channel":
            parseStack.append(elementName)
        case "item":
            parseStack.append(elementName)
            tempItem = Item()
//            println("parsing item: \(elementName)")
        case "title":
            parseStack.append(elementName)
        case "lastBuildDate":
            parseStack.append(elementName)
        case "pubDate":
            parseStack.append(elementName)
        case "link":
            parseStack.append(elementName)
        case "description":
            parseStack.append(elementName)
        case "dc:creator":
            parseStack.append(elementName)
        default: break
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "channel":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
        case "item":
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
                case "channel":
                    feedData!.siteName = currentContent!.html2String
                case "item":
                    tempItem?.title = currentContent!.html2String
                default: break
                }
            }
        case "lastBuildDate":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            if !parseStack.isEmpty {
                switch parseStack.last! {
                case "channel":
                    feedData!.lastBuildDate = RssParser.dateFromPubDate(currentContent!)
                default: break
                }
            }
        case "pubDate":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            if !parseStack.isEmpty {
                switch parseStack.last! {
                case "channel":
                    feedData!.pubDate = RssParser.dateFromPubDate(currentContent!)
                case "item":
                    tempItem?.pubDate = RssParser.dateFromPubDate(currentContent!)
                default: break
                }
            }
        case "link":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            if !parseStack.isEmpty {
                switch parseStack.last! {
                case "channel":
                    feedData!.siteUrl = currentContent
                case "item":
                    tempItem?.link = currentContent
                default: break
                }
            }
        case "description":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            if !parseStack.isEmpty {
                switch parseStack.last! {
                case "channel":
                    feedData!.siteDescription = currentContent!.html2String // filter out html tags and symbols
                case "item":
                    tempItem?.summary = currentContent!.html2String // filter out html tags and symbols
                default: break
                }
            }
        case "dc:creator":
            if !parseStack.isEmpty {
                parseStack.removeLast()
            }
            if !parseStack.isEmpty {
                switch parseStack.last! {
                case "item":
                    tempItem?.author = currentContent!.html2String
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
        for format in RFC822 {
            dateFormatter.dateFormat = format
            if let parsedDate = dateFormatter.dateFromString(date) {
                return parsedDate
            }
        }
        return nil
    }
    
    
}