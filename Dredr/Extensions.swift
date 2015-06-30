//
//  Extensions.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/24/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var html2String: String {
        var plainText =  NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: NSNumber(unsignedLong: NSUTF8StringEncoding)], documentAttributes: nil, error: nil)!.string
        let result = plainText.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        return result
    }
}

func daysFromDate(date: NSDate, toDate: NSDate) -> Int {
    var calendar = NSCalendar.currentCalendar()
    
    let date_1 = calendar.startOfDayForDate(date)
    let date_2 = calendar.startOfDayForDate(toDate)
    
    let components = calendar.components(.CalendarUnitDay, fromDate: date_1, toDate: date_2, options: nil)
    
    return components.day
}

//extension String
//{
//    var html2String: String {
//        var plainText = self
//        let htmlEscapes = ["&": "&amp;", "<": "&lt;", ">": "&gt;"]
//        let blankEscapes = ["&nbsp"]
//        
//        for (key, value) in htmlEscapes {
//            plainText = plainText.stringByReplacingOccurrencesOfString(value, withString: key)
//        }
//        
//        for blankChar in blankEscapes {
//            plainText = plainText.stringByReplacingOccurrencesOfString(blankChar, withString: "")
//        }
//        
//        var regexFiltered = NSMutableString(string: plainText)
//        let regex = NSRegularExpression(pattern: "<(?:\"[^\"]*\"['\"]*|'[^']*'['\"]*|[^'\">])+>", options: .DotMatchesLineSeparators, error: nil)
//        regex!.replaceMatchesInString(regexFiltered, options: .allZeros, range: NSMakeRange(0, count(plainText)) , withTemplate: "")
//        
//        return "\(regexFiltered)"
//    }
//}

