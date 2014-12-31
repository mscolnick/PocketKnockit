//
//  RecentsViewController.swift
//  PocketKnockit
//
//  Created by Myles Scolnick on 12/23/14.
//  Copyright (c) 2014 WDMD. All rights reserved.
//

import UIKit

class RecentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var recievedNotificationArray: NSMutableArray = NSMutableArray()
    var sentNotificationArray: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("Loading Recents View...")
        self.queryData()
        println("Loaded View.")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        // IF ERROR CHECK HERE
        var CellIdentifier:NSString = "NotificationCell"
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as UITableViewCell

        var obj:PFObject?
        if (self.segControl.selectedSegmentIndex == 0){
            var count: NSInteger = self.recievedNotificationArray.count
            obj = self.recievedNotificationArray.objectAtIndex(count-indexPath.row-1) as? PFObject
        }else{
            var count: NSInteger = self.sentNotificationArray.count
            obj = self.sentNotificationArray.objectAtIndex(count-indexPath.row-1) as? PFObject
        }

        var cellText:NSString = obj?["message"] as NSString
        cell.textLabel?.text = cellText
        var date:NSString = obj?["date"] as NSString
        cell.detailTextLabel?.text = date
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.segControl.selectedSegmentIndex == 0){
            return self.recievedNotificationArray.count
        }else{
            return self.sentNotificationArray.count
        }
    }
    
    func queryData(){
        
        println("Querying...")
        
        var currentUserId = ""
        if (PFUser.currentUser() == nil){
            println("Current User is nil")
            currentUserId = "0"
        }else{
            currentUserId = PFUser.currentUser().objectId
        }
        
        var query:PFQuery = PFQuery(className: "History")
        query.whereKey("recipientId", equalTo: currentUserId)
        query.limit = 30
        query.findObjectsInBackgroundWithBlock { (notifications: [AnyObject]!, error: NSError!) -> Void in
            if(error == nil){
                self.recievedNotificationArray = (notifications as NSArray).mutableCopy() as NSMutableArray
                self.tableView.reloadData()
            }
        }
        
        var query2:PFQuery = PFQuery(className: "History")
        query2.whereKey("senderId", equalTo: currentUserId)
        query2.limit = 30
        query2.findObjectsInBackgroundWithBlock { (notifications: [AnyObject]!, error: NSError!) -> Void in
            if(error == nil){
                self.sentNotificationArray = (notifications as NSArray).mutableCopy() as NSMutableArray
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func changedSegControl(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        self.queryData()
    }
}
