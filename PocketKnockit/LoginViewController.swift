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
    
    var currentSessionUser:PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = PFUser.currentUser(){
            //if we are already logged in at application open
            if(PFFacebookUtils.isLinkedWithUser(user)){
                PFFacebookUtils.initializeFacebook()
                self.performSegueWithIdentifier("Login", sender: nil)
            }
        }
        PFFacebookUtils.initializeFacebook()
    }
    
    
    func storeFacebookInfo(){
        println("Storing Facebook info")
        var request:FBRequest = FBRequest.requestForMe()
        request.startWithCompletionHandler { (FBRequestConnection connection, AnyObject result, NSError error) -> Void in
            if(error == nil){
                var userData:NSDictionary = result as NSDictionary
                var facebookId:NSString = userData["id"] as NSString
                var pictureURL:NSURL = NSURL(string: "https://graph.facebook.com/\(facebookId)/picture?width=200&height=200")!
                PFUser.currentUser()["profilePictureUrl"] = pictureURL.absoluteString
                PFUser.currentUser()["facebookId"] = facebookId
                var firstName:NSString = userData["first_name"] as NSString
                var lastName:NSString = userData["last_name"] as NSString
                PFUser.currentUser()["displayName"] = firstName + " " + lastName
                PFUser.currentUser().saveInBackgroundWithBlock(nil)
            }else{
                println("Take Care of Error")
                println(error)
            }
        }
    }

    
    @IBAction func loginButtonHandler(sender: AnyObject) {
        println("Logging In")
        var permissions:NSArray = ["user_friends"]
        PFFacebookUtils.initializeFacebook()
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            
            self.currentSessionUser = user
            if user == nil {
                if(error == nil){
                    println("Uh oh. The user cancelled the Facebook login.")
                    var alert = UIAlertController(title: "Log In Error", message: "You have cancelled the Facebook login.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }else{
                    println("Login Error Occured.")
                    println(error)
                    var alert = UIAlertController(title: "Log In Error", message: "Login Failed", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            } else if user.isNew {
                println("User signed up and logged in through Facebook!")
                self.storeFacebookInfo()
                self.performSegueWithIdentifier("Login", sender: nil)
            } else {
                println("User logged in through Facebook!")
                self.storeFacebookInfo()
                self.performSegueWithIdentifier("Login", sender: nil)
                //TODO
                //[[PFUser currentUser] refresh];
            }
        })
    }
}