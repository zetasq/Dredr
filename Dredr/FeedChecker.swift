//
//  FeedChecker.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/24/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation

enum FeedFormat: Printable {
    case RSS
    case Atom
    case Unidentified
    
    var description: String {
        switch self {
        case .RSS:
            return "RSS"
        case .Atom:
            return "Atom"
        case .Unidentified:
            return "Unidentified"
        }
    }
}

struct FeedCheckResult {
    var feedFormat: FeedFormat
    var updatedDate: NSDate!
}

class FeedChecker: NSObject, NSXMLParserDelegate
{
    static var defaultChecker = FeedChecker()
    
    private var checkResult: FeedCheckResult!
    
    // These three date variables are used to determine the updatedDate in checkResult
    private var lastBuildDate: NSDate!
    private var pubDate: NSDate!
    private var updated: NSDate!
    
    var currentElement: String!
    var currentContent: String!
    
    var itemCounter = 0
    
    private override init() { }
    
    func checkFeedDataFormat(feedData: NSData) -> FeedCheckResult {
        checkResult = FeedCheckResult(feedFormat: .Unidentified, updatedDate: nil)
        itemCounter = 0
        
        var parser = NSXMLParser(data: feedData)
        parser.delegate = self
        parser.shouldProcessNamespaces = true
        parser.parse()
        
        return checkResult
    }
    
    private func chooseEffectiveDate() { // update checkResult.updatedDate from pubDate, lastBuildDate, updated
        switch checkResult.feedFormat {
        case .RSS:
            switch (lastBuildDate, pubDate) {
            case (nil, nil): checkResult.updatedDate = nil
            case (_, nil): checkResult.updatedDate = lastBuildDate
            case (nil, _): checkResult.updatedDate = pubDate
            case (_, _): checkResult.updatedDate = lastBuildDate
            }
        case .Atom:
            checkResult.updatedDate = updated
        case .Unidentified: break
        }
    }
    
    
    // MARK: XML Parser delegate
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
//        println("\(elementName)")
        currentContent = ""
        switch elementName {
        case "rss":
            checkResult.feedFormat = .RSS
        case "feed":
            if namespaceURI == "http://www.w3.org/2005/Atom" {
                checkResult.feedFormat = .Atom
            }
        case "pubDate":
            currentElement = elementName
        case "lastBuildDate":
            currentElement = elementName
        case "updated":
            currentElement = elementName
        case "item": // check until the second item
            itemCounter++
            if itemCounter > 1 {
                chooseEffectiveDate()
                parser.abortParsing()
            }
        case "entry": // check until the second entry
            itemCounter++
            if itemCounter > 1 {
                chooseEffectiveDate()
                parser.abortParsing()
            }
        default: break
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        currentContent! += string!
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "pubDate":
            if pubDate == nil {
                pubDate = RssParser.dateFromPubDate(currentContent)
            }
        case "lastBuildDate":
            if lastBuildDate == nil {
                lastBuildDate = RssParser.dateFromPubDate(currentContent)
            }
        case "updated":
            if updated == nil {
                updated = AtomParser.dateFromPubDate(currentContent)
            }
        default: break
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) { // normally this func won't be called, unless we are parsing an empty feed (with 0 items or entries)
        chooseEffectiveDate()
        parser.abortParsing()
    }
    
}