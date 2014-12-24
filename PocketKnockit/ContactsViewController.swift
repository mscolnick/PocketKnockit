//
//  ContactsViewController.swift
//  PocketKnockit
//
//  Created by Myles Scolnick on 12/23/14.
//  Copyright (c) 2014 WDMD. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var freindsArray:NSMutableArray = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: CGRectZero)
        var CellIdentifier:NSString = "ContactCell"
        var cell:ContactTableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? ContactTableViewCell
        
        if (cell == nil) {
            cell = ContactTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        //CHECK HERE IF PROBLEM
        
        var obj:PFObject = self.freindsArray.objectAtIndex(indexPath.row) as PFObject
        var cellText:NSString = obj["displayName"] as NSString
        cell?.textLabel.text = cellText
        var pictureUrl:NSString = obj["profilePictureURL"] as NSString
        var img:UIImage = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: pictureUrl)!)!)!
        cell?.imageView.image = img
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
        return self.freindsArray.count
    }
    
    func refreshTable(){
        self.tableView.reloadData()
    }
    
    func queryFacebookFriends(){
        //TODO: refactor below code
        
        //    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        //        if (!error) {
        //            NSArray *friendObjects = [result objectForKey:@"data"];
        //            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
        //            for (NSDictionary *friendObject in friendObjects) {
        //                [friendIds addObject:[friendObject objectForKey:@"id"]];
        //            }
        //            PFQuery *friendQuery = [PFUser query];
        //            [friendQuery whereKey:@"facebookId" containedIn:friendIds];
        //
        //            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //                self.friendArray = [objects mutableCopy];
        //                [self refreshTable];
        //            }];
        //        }
        //    }];
    }
    
}

