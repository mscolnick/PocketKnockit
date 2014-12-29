//
//  ContactsViewController.swift
//  PocketKnockit
//
//  Created by Myles Scolnick on 12/23/14.
//  Copyright (c) 2014 WDMD. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friendsArray:NSMutableArray = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.queryFacebookFriends()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        tableView.tableFooterView = UIView(frame: CGRectZero)
        var CellIdentifier:NSString = "ContactCell"
        var cell:ContactTableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? ContactTableViewCell
        
        if (cell == nil) {
            cell = ContactTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        var obj:PFObject = self.friendsArray.objectAtIndex(indexPath.row) as PFObject
        var cellText:NSString = obj["displayName"] as NSString
        cell?.textLabel?.text = cellText
        if let profileUrlString: NSString = obj["profilePictureURL"] as? NSString{
            var url:NSURL = NSURL(string: profileUrlString)!
            var imageData:NSData = NSData(contentsOfURL: url)!
            cell?.imageView?.image = UIImage(data:imageData)
        }else{
            println("No Profile Picture")
        }
        
        
        var def:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var defaultValue = 3;
        if(def.objectForKey(obj.objectId) == nil){
            def.setInteger(defaultValue, forKey: obj.objectId)
            def.synchronize()
        }

        cell?.numberField.text = "\(def.integerForKey(obj.objectId))"
        cell?.idForCell = obj.objectId
        //check to see if an entry exists in NSUser defualts
        //if it does not, set it to default value
        //set the field
        
        return cell!;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsArray.count
    }
    
    func refreshTable(){
        self.tableView.reloadData()
    }
    
    func queryFacebookFriends(){
        //CHECK IF WORKS BEFORE DELETING:
        /*
            [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSArray *friendObjects = [result objectForKey:@"data"];
                    NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
                    for (NSDictionary *friendObject in friendObjects) {
                        [friendIds addObject:[friendObject objectForKey:@"id"]];
                    }
                    PFQuery *friendQuery = [PFUser query];
                    [friendQuery whereKey:@"facebookId" containedIn:friendIds];
        
                    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        self.friendArray = [objects mutableCopy];
                        [self refreshTable];
                    }];
                }
            }];
        */
        FBRequestConnection.startForMyFriendsWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                println(result)
                var friendObjects:NSArray = result["data"] as [NSDictionary]
                println(friendObjects)
                var friendIds:NSMutableArray = NSMutableArray(capacity: friendObjects.count)
                for friendObject in friendObjects {
                    friendIds.addObject(friendObject["id"] as NSString)
                }
                println(friendIds)
                var friendQuery: PFQuery = PFUser.query()
                friendQuery.whereKey("facebookId", containedIn: friendIds)
                friendQuery.findObjectsInBackgroundWithBlock({ (NSArray objects, NSError error) -> Void in
                    println(error)
                    println(objects)
                    self.friendsArray = (objects as NSArray).mutableCopy() as NSMutableArray
                    println(self.friendsArray)
                    self.refreshTable()
                })
                println("Recived Friends")
            } else {
                println("Error requesting friends list form facebook")
                println("\(error)")
            }
        }
        
    }
    
}

