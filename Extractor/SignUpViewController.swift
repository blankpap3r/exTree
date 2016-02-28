//
//  SignUpViewController.swift
//  Extractor
//
//  Created by Кирилл on 2/28/16.
//  Copyright © 2016 BrainDump. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField:                UITextField!
    @IBOutlet weak var passwordTextField:             UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpButtonPressed() {
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        if emailTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" ||
        passwordTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" ||
        passwordConfirmationTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" ||
        passwordTextField.text != passwordConfirmationTextField.text {
            return
        }
        
        let email       = emailTextField.text!
        let password    = passwordTextField.text!
        let phoneNumber = phoneNumberTextField.text!
        
        signUpButton.enabled = false
        
        let user = User()
        user.username    = email
        user.email       = email
        user.password    = password
        user.phoneNumber = phoneNumber
        user.signUpInBackgroundWithBlock {
            (success, error) -> Void in
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.tryToLoadMainApp()
            
            self.signUpButton.enabled = true
        }
    }

}
