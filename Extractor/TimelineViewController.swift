//
//  TimelineViewController.swift
//  Extractor
//
//  Created by Кирилл on 2/28/16.
//  Copyright © 2016 BrainDump. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {
    
    var type: String!
    
    var stories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if type == "myStories" {
            ServerManager.loadMyLastContributions {
                (error, texts) -> Void in
                if error != nil {
                    print(error)
                    return
                }
                
                self.stories = texts!
                self.tableView.reloadData()
            }
        } else if type == "topStories" {
            ServerManager.loadTopStories({
                (error, texts) -> Void in
                if error != nil {
                    print(error)
                    return
                }
                
                self.stories = texts!
                self.tableView.reloadData()
            })
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell") as! StoryCell
        cell.storyTextField.text = stories[indexPath.row]
        
        
        cell.layer.shadowOffset = CGSizeMake(5, 5)
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowRadius = 10
        cell.layer.shadowOpacity = 1
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
