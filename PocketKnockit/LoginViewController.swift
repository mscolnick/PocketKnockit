//
//  LoginViewController.swift
//  PocketKnockit
//
//  Created by Weston Mizumoto on 12/27/14.
//  Copyright (c) 2014 WDMD. All rights reserved.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController {

    
    
    @IBAction func loginButtonHandler(sender: AnyObject) {
        var permissions:NSArray = ["user_friends"]
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                self.performSegueWithIdentifier("Login", sender: nil)


            } else {
                NSLog("User logged in through Facebook!")
                self.performSegueWithIdentifier("Login", sender: nil) 
            }
        })
        
        
    }

}