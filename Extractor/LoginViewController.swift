//
//  LoginViewController.swift
//  Extractor
//
//  Created by Кирилл on 2/27/16.
//  Copyright © 2016 BrainDump. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import PKHUD

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        decorateButton(facebookLoginButton,color: UIColor(red: 0.231, green: 0.349, blue: 0.596, alpha: 1.0) )
        decorateButton(emailSignUpButton, color: UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1))
      
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){
        
    }
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var emailSignUpButton: UIButton!
    
    
    private func decorateButton(button: UIButton, color: UIColor) {
        
        if (button == facebookLoginButton) {
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        } else {
            button.setTitleColor(UIColor(red: 0.961, green: 0.231, blue: 0.231, alpha: 1), forState: UIControlState.Normal)
        }
        
        button.layer.borderColor = color.CGColor
        button.backgroundColor = color;
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 7
    }
    
    @IBAction func facebookLoginButtonPressed() {
        let permissions = ["public_profile"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user, error) -> Void in
            if let user = user {
                if user.isNew {
                    let newUser = UIAlertController(title: "Congrats!", message: "You have been Signed up and Logged in through Facebook.", preferredStyle: UIAlertControllerStyle.Alert)
                    newUser.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(newUser, animated: true, completion: nil)
                } else {
                    HUD.flash(.LabeledProgress(title: "Facbook LogIn", subtitle: "Logging In..."), withDelay: 0.5)
                    // Now some long running task starts...
                    self.delay(1.2) {
                        // ...and once it finishes we flash the HUD for a second.
                        HUD.flash(.Success, withDelay: 1.5)
                    }
                }
                
                self.updateCurrentUserInfoFromFacebook()
            } else {
                let logInCancel = UIAlertController(title: "Failed", message: "Uh oh. The user cancelled the Facebook Log In!", preferredStyle: UIAlertControllerStyle.Alert)
                logInCancel.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(logInCancel, animated: true, completion: nil);
            }

            self.delay(2.2) {
                let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
                appDel.tryToLoadMainApp()
            }
        })
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let email    = usernameField.text!
        let password = passwordField.text!
        
        let user = User()
        user.username = email
        user.email    = email
        user.password = password
        
        user.signUpInBackgroundWithBlock {
            (success, error) -> Void in
            
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            appDel.tryToLoadMainApp()
        }
    }
    
    func updateCurrentUserInfoFromFacebook() {
        let currentUser = PFUser.currentUser() as! User
        
        let requestParameters = ["fields": "id, name"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        graphRequest.startWithCompletionHandler({
            (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            
            if error != nil {
                print("Error occured when executing GraphRequest")
                print(error)
            } else {
                print("Feched user: \(result)")
                
                if let fullName = result.valueForKey("name") as? String {
                    currentUser.fullName = fullName
                    currentUser.saveInBackground()
                } else {
                    print("Unable to update user's info with facebook")
                }
            }
        })
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
