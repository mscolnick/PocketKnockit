//
//  MoreTableViewController.swift
//  PocketKnockit
//
//  Created by Myles Scolnick on 12/27/14.
//  Copyright (c) 2014 WDMD. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
    
    @IBOutlet var moreTableView: UITableView!
    
    @IBOutlet weak var enablePocketKnockitSwitch: UISwitch!
    @IBOutlet weak var enableVibrationFeedbackSwitch: UISwitch!
    
    @IBOutlet weak var enablePocketKnockitLabel: UILabel!
    @IBOutlet weak var vibrationFeedbackLabel: UILabel!

    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    var links:[String:String] = [
        "Rate": "https://itunes.com",
        "Facebook": "https://facebook.com",
        "Twitter": "https://twitter.com",
        "Instagram": "https://instagram.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(self.enableVibrationFeedbackSwitch.on == true){
            self.vibrationFeedbackLabel.text = "On"
        }else{
            self.vibrationFeedbackLabel.text = "Off"
        }
        if(self.enablePocketKnockitSwitch.on == true){
            self.enablePocketKnockitLabel.text = "On"
        }else{
            self.enablePocketKnockitLabel.text = "Off"
        }
        
        if let profileUrlString: NSString = PFUser.currentUser()["profilePictureUrl"] as? NSString{
            var url:NSURL = NSURL(string: profileUrlString)!
            var imageData:NSData = NSData(contentsOfURL: url)!
            profilePicture.image = UIImage(data:imageData)
        }else{
            println("No Profile Picture")
        }
        
        if let profileDisplayName: NSString = PFUser.currentUser()["displayName"] as? NSString{
            self.profileName.text = profileDisplayName
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Clicked")
        
        var identifier:NSString? = tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier
        
        if(identifier == nil){
            println("Error: No identifier")
            // so cell wont stay highlighted
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        println(identifier)
        
        if var link:NSString = self.links[identifier!]{
            println("Valid Link")
            self.goToLink(link)
        }
        
        if(identifier == "Share"){
            println("Sharing")
            var string:NSString = "Checkout PocketKnockit! Download Here:"
            var url:NSURL = NSURL(string: "https://www.google.com/search?q=pocketknockit")!
            
            var activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [string,url], applicationActivities: nil)
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        
        if(identifier == "Logout"){
            FBSession.activeSession().closeAndClearTokenInformation()
        }
        if(identifier == "Policy"){
            println("Policy")
        }
        
        
        // so cell wont stay highlighted
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func goToLink(link: NSString){
        var url = NSURL(string: link)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    //  button that enables/dissables vibration feedback
    @IBAction func toggleVibrationFeedback(sender: AnyObject) {
        if(self.enableVibrationFeedbackSwitch.on == true){
            self.vibrationFeedbackLabel.text = "On"
        }else{
            self.vibrationFeedbackLabel.text = "Off"
        }
    }
    
    // button that enables/disables PocketKnockit
    @IBAction func togglePocketKnockit(sender: AnyObject) {
        if(self.enablePocketKnockitSwitch.on == true){
            self.enablePocketKnockitLabel.text = "On"
        }else{
            self.enablePocketKnockitLabel.text = "Off"
        }
    }
    
}
