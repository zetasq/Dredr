//
//  DsNavigationController.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/16/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class DsNavigationController: UINavigationController {

    func config() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        config()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
