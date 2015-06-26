//
//  FeedlyRequest.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/26/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation

public class FeedlyRequest
{
    var searchTerm: String
    
    init(searchTerm: String) {
        self.searchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "%20")
    }
    
    public func fetch(completion: (results: [FeedlyResult]?) -> Void) {
        fetchSearchResult {
            (data, error) -> Void in
            if data != nil {
                let json = JSON(data: data!)
                var searchResults: [FeedlyResult] = []
                
                if let resultArray = json["results"].array {
                    for eachResult in resultArray {
                        if let feedlyResult = FeedlyResult(json: eachResult) {
                            searchResults.append(feedlyResult)
                        }
                    }
                    completion(results: searchResults)
                } else {
                    completion(results: nil)
                }
            } else {
                completion(results: nil)
            }
        }
    }
    
    private func fetchSearchResult(completion: (data: NSData?, error: NSError?) -> Void) {
        let url = NSURL(string: "http://cloud.feedly.com/v3/search/feeds?query=\(searchTerm)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.DSoftware", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        }
        task.resume()
    }
}