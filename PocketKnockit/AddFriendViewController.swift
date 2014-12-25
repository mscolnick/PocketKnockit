//
//  AddFriendViewController.swift
//  PocketKnockit
//
//  Created by Myles Scolnick on 12/24/14.
//  Copyright (c) 2014 WDMD. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addFriendTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAddFriend(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: CGRectZero)
        var CellIdentifier:NSString = "AddFriendCell"
        var cell:UITableViewCell? = self.addFriendTableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
}

