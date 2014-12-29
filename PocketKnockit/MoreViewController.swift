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
    
    var links:[String:String] = [
        "Rate PocketKnockit": "https://itunes.com",
        "Like us on Facebook": "https://facebook.com",
        "Follow us on Twitter": "https://twitter.com",
        "Follow us on Instagram": "https://instagram.com"]
    
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view:UIView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 65.0))
        view.backgroundColor = UIColor.grayColor()
        
        var label: UILabel = UILabel(frame: CGRectMake(10, 30, tableView.frame.size.width, 25.0))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.cyanColor()
        label.font = UIFont(name: "Avenir", size: 22.0)
        
        var sectionTitle: NSString = self.tableView(tableView, titleForHeaderInSection: section)!
        label.text = sectionTitle
        
        view.addSubview(label)
        
        return view
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var sectionItems:NSArray = self.items.objectForKey(self.sectionTitles.objectAtIndex(indexPath.section)) as NSArray
        var item:NSString = sectionItems.objectAtIndex(indexPath.row) as NSString
        
        if var link:NSString = self.links[item]{
            println("Valid Link")
            var url = NSURL(string: link)
            UIApplication.sharedApplication().openURL(url!)
        }
        
        if(item == "Share"){
            println("Sharing")
            var string:NSString = "Checkout PocketKnockit! Download Here:"
            var url:NSURL = NSURL(string: "https://www.google.com/search?q=pocketknockit")!
            
            var activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [string,url], applicationActivities: nil)
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        
        println("No Link")
        
        // so cell wont stay highlighted
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}