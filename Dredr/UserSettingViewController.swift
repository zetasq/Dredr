//
//  UserSettingController.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/26/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dmBoard = DMBoard.sharedBoard
    var account: Account!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let UsernameSettingCellIdentifier = "UsernameSettingCell"
    let FetchSettingCellIdentifier = "FetchSettingCell"
    let StorageTimeSettingCellIdentifier = "StorageTimeSettingCell"
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

extension UserSettingViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Username"
        } else {
            return "User preference"
        }
    }
    
    // Do the shit again :(
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        
        if section == 0 {
            headerView.textLabel.text = "Username"
        } else {
            headerView.textLabel.text = "User preference"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(UsernameSettingCellIdentifier, forIndexPath: indexPath) as! UsernameSettingCell
            
            cell.account = account
            cell.nameField.delegate = self
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(FetchSettingCellIdentifier, forIndexPath: indexPath) as! FetchSettingCell
            
                cell.account = account
            
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(StorageTimeSettingCellIdentifier, forIndexPath: indexPath) as! StorageTimeSettingCell
                
                cell.storageTimePickerView.dataSource = self
                cell.storageTimePickerView.delegate = self
                
                let storageDaysIndex = find(storageDaysSource, account.userConfig.storageDays)
                cell.storageTimePickerView.selectRow(storageDaysIndex!, inComponent: 0, animated: false)
                
                return cell 
            }
        }
    }
}

extension UserSettingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return storagePickerTitles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return storagePickerTitles[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        account.userConfig.storageDays = storageDaysSource[row]
    }
}

extension UserSettingViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text.isEmpty {
            return false
        } else {
            if dmBoard.hasAccountNamed(textField.text, except: account) {
                let alert = UIAlertController(title: "Username already used", message: "This username has already used by another account", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                presentViewController(alert, animated: true, completion: nil)
                
                return false
            } else {
                account.userName = textField.text
                textField.resignFirstResponder()
                return true
            }
        }
    }
}
