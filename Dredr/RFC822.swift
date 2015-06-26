//
//  RFC822.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/24/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import Foundation

// RFC822 is the date and time specification RSS conforms to.

let RFC822 = [
    "EEE, d MMM yyyy HH:mm:ss zzz", // Sun, 19 May 2002 15:21:36 GMT
    "EEE, d MMM yyyy HH:mm zzz", // Sun, 19 May 2002 15:21 GMT
    "EEE, d MMM yyyy HH:mm:ss", // Sun, 19 May 2002 15:21:36
    "EEE, d MMM yyyy HH:mm", // Sun, 19 May 2002 15:21
    "d MMM yyyy HH:mm:ss zzz", // 19 May 2002 15:21:36 GMT
    "d MMM yyyy HH:mm zzz", // 19 May 2002 15:21 GMT
    "d MMM yyyy HH:mm:ss", // 19 May 2002 15:21:36
    "d MMM yyyy HH:mm", // 19 May 2002 15:21
    ]

                