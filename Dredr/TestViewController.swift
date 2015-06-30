//
//  TestViewController.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/29/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeiCloudAccessWithCompletion { (success) -> Void in
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeiCloudAccessWithCompletion(completion: (Bool) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let iCloudRoot = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if iCloudRoot != nil {
                    println("iCloud availabel at \(iCloudRoot)")
                    completion(true)
                } else {
                    println("iCloud not available")
                    completion(false)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
