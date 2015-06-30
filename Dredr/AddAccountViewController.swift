//
//  AddAccountViewController.swift
//  Dredr
//
//  Created by Zhu Shengqi on 5/29/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {
    
    var dmBoard = DMBoard.sharedBoard
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var backgroundFetchSwitch: UISwitch!
    @IBOutlet weak var storageDaysPickerView: UIPickerView!
    
    // MARK: Interaction Calls
    let FinishAddIdentifier = "AddAccount"
    
    @IBAction func cancelAdd(sender: AnyObject) {
        performSegueWithIdentifier(FinishAddIdentifier, sender: self)
    }
    
    @IBAction func addAccount(sender: AnyObject) {
        if let userName = nameField.text {
            if !userName.isEmpty {
                if dmBoard.hasAccountNamed(userName) {
                    let alert = UIAlertController(title: "Account already exists", message: "An account with this name has already been created", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(defaultAction)
                    presentViewController(alert, animated: true, completion: nil)
                } else {
                    let allowsBackgroundFetch = backgroundFetchSwitch.on
                    let storageDays = storageDaysSource[storageDaysPickerView.selectedRowInComponent(0)]
                    let config = UserConfig(accountType: .Local, allowsBackgroundFetch: allowsBackgroundFetch, storageDays: storageDays)
                    
                    dmBoard.addAccount(userName, config: config)
                    performSegueWithIdentifier(FinishAddIdentifier, sender: self)
                }
            } else {
                let alert = UIAlertController(title: "Username Missing", message: "Type your username to add a account", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        nameField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension AddAccountViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return storagePickerTitles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return storagePickerTitles[row]
    }
}

extension AddAccountViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}