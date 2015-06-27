//
//  SettingsViewController.swift
//  Dredr
//
//  Created by Zhu Shengqi on 6/26/15.
//  Copyright (c) 2015 DSoftware. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var dmBoard = DMBoard.sharedBoard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        // these attributes should be reset in neighbour's viewWillAppear() if default behavior is desired
        navigationController?.navigationBar.barStyle = .Default // black status bar
        navigationController?.navigationBar.shadowImage = nil // shadow for navigationbar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default) // make navigationbar totally translucent
        navigationController?.navigationBar.tintColor = UIColor(red: 128.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1.0) // tint the back arrow
    }
    
    let AccountSettingCellIdentifier = "AccountSettingCell"
    let AboutProjectCellIdentifier = "AboutProjectCell"
    
    // MARK: - Navigation
    
    let ShowUserSettingIdentifier = "ShowUserSetting"
    let ShowAboutPageIdentifier = "ShowAboutPage"
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ShowUserSettingIdentifier {
            if let userSettingVC = segue.destinationViewController as? UserSettingViewController {
                userSettingVC.account = dmBoard.accounts[tableView.indexPathForSelectedRow()!.row]
                return
            }
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if dmBoard.accounts.isEmpty {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if dmBoard.accounts.isEmpty {
            return "Dredr"
        } else {
            if section == 0 {
                return "Accounts"
            } else {
                return "Dredr"
            }
        }
    }
    
    // Why implement this func? Because someone really stupid in Apple just turns all the headertitls into uppercase, so we had to change the text again
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        
        if dmBoard.accounts.isEmpty {
            headerView.textLabel.text = "Dredr"
        } else {
            if section == 0 {
                headerView.textLabel.text = "Accounts"
            } else {
                headerView.textLabel.text = "Dredr"
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dmBoard.accounts.isEmpty {
            return 1
        } else {
            if section == 0 {
                return dmBoard.accounts.count
            } else {
                return 1
            }
        }
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if dmBoard.accounts.isEmpty {
            let cell = tableView.dequeueReusableCellWithIdentifier(AboutProjectCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            return cell
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(AccountSettingCellIdentifier, forIndexPath: indexPath) as! AccountSettingCell
                
                cell.account = dmBoard.accounts[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(AboutProjectCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if dmBoard.accounts.isEmpty {
            performSegueWithIdentifier(ShowAboutPageIdentifier, sender: self)
            return
        } else {
            if indexPath.section == 0 {
                performSegueWithIdentifier(ShowUserSettingIdentifier, sender: self)
                return
            }
            
            if indexPath.section == 1 {
                performSegueWithIdentifier(ShowAboutPageIdentifier, sender: self)
                return
            }
        }
    }
}
