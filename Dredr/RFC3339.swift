//
//  RFC3339.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/24/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation

// RFC3339 is the date and time specification Atom conforms to.

let RFC3339 = [
    "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ", // 1996-12-19T16:39:57-0800
    "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ", // 1937-01-01T12:00:27.87+0020
    "yyyy'-'MM'-'dd'T'HH':'mm':'ss" // 1937-01-01T12:00:27
    ]