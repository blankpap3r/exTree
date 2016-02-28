//
//  SettingsViewController.swift
//  Extractor
//
//  Created by Rahul Shrestha on 2/27/16.
//  Copyright © 2016 BrainDump. All rights reserved.
//

import UIKit
import Parse
import PKHUD

class SettingsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var settingsTable: UITableView!
   
    // provides the number of section header titles
    let headerTitlesForSection = ["", " "," "]
    let rowData = [["User Info"],["Privacy Settings", "Info Settings", "Notification Settings"] , ["Log Out"]]
    
    override func viewDidLoad() {
        if Reachability.isConnectedToNetwork() == true {
            super.viewDidLoad()
            
            self.settingsTable.dataSource=self
            self.settingsTable.delegate=self
        } else {
            print("Internet connection FAILED")
            HUD.flash(.LabeledProgress(title: "Checking Network", subtitle: ""), withDelay: 1.5)
            // Now some long running task starts...
            self.delay(1.2) {
                let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
    }
    
    
    // provide the number of section to the table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headerTitlesForSection.count
    }
    
    // provide the number of rows in each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rowData[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitlesForSection.count {
            return headerTitlesForSection[section]
        }
        
        return nil
    }
    
    
    // provide data for each section
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = rowData[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            
            PFUser.logOut()
            HUD.flash(.LabeledProgress(title: "Logging Out", subtitle: ""), withDelay: 0.5)
            // Now some long running task starts...
            self.delay(1.2) {
                // ...and once it finishes we flash the HUD for a second.
                HUD.flash(.Success, withDelay: 2.0)
            }
            self.delay(2.5){
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.tryToLoadMainApp()
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }


}
