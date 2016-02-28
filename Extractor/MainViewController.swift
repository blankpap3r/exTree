//
//  MainViewController.swift
//  Extractor
//
//  Created by Кирилл on 2/27/16.
//  Copyright © 2016 BrainDump. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var emptyNotice:          UILabel!
    @IBOutlet weak var ancestorDataTextView: UITextView!
    @IBOutlet weak var newDataTextField:     UITextField!
    
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        loadNext()
        
        if (ancestorDataTextView.text != ""){
            emptyNotice.hidden = true
        }
    }
    
    func configureView() {
        self.submitButton.enabled = false
        self.rejectButton.enabled = false
    }

    @IBAction func submitButtonPressed() {
        if newDataTextField.text! == "" {
            return
        }
        
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        if newDataTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
            return
        }
        
        submitButton.enabled = false
        let newData = newDataTextField.text!
        ServerManager.push(newData, handler: {
            (success) -> Void in
            if success {
                self.loadNext()
                
                self.enableButtons()
                self.newDataTextField.text = ""
            }
        })
    }
    
    @IBAction func rejectButtonPressed() {
        disableButtons()
        
        ServerManager.reject({
            (success) -> Void in
            self.loadNext()
        })
    }
    
    // MARK: - Helper methods
    func loadNext() {
        disableButtons()
        
        ServerManager.pull({
            (error, text) -> Void in
            if error != nil {
                print("Error occured while pulling data from server. Error: ", error)
                return
            }
            
            if text == "" {
                self.emptyNotice.hidden = false
            } else {
                self.emptyNotice.hidden = true
            }
            
            self.ancestorDataTextView.text = text
            self.enableButtons()
        })
    }
    
    func enableButtons() {
        submitButton.enabled = true
        rejectButton.enabled = true
    }
    
    func disableButtons() {
        submitButton.enabled = false
        rejectButton.enabled = false
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMyStories" {
            let destVC = segue.destinationViewController as! TimelineViewController
            destVC.type = "myStories"
        } else if segue.identifier == "showTopStories" {
            let destVC = segue.destinationViewController as! TimelineViewController
            destVC.type = "topStories"
        }
    }
    
}

