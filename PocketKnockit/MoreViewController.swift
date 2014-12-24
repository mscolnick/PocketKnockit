//
//  MoreViewController.swift
//  PocketKnockit
//
//  Created by Myles Scolnick on 12/23/14.
//  Copyright (c) 2014 WDMD. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items:NSDictionary = [
        "Spread The Word": ["Share", "Rate PocketKnockit", "Like us on Facebook", "Follow us on Twitter", "Follow us on Instagram"],
        "Settings": ["View Graph", "Vibrate Feedback", "Enable PocketKnockit", "Logout of Facebook"],
        "Other Stuff": ["Terms and Conditions", "Privacy Policy", "Rules"]]
    
    var sectionTitles:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sectionTitles = self.items.allKeys
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles.objectAtIndex(section) as? String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionItems:NSArray = self.items.objectForKey(self.sectionTitles.objectAtIndex(section)) as NSArray
        return sectionItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var CellIdentifier:NSString = "MoreCell"
        var cell:UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        // Configure the cell...
        var sectionItems:NSArray = self.items.objectForKey(self.sectionTitles.objectAtIndex(indexPath.section)) as NSArray
        var item:NSString = sectionItems.objectAtIndex(indexPath.row) as NSString
        cell?.textLabel.text = item
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
}