//
//  AddFriendViewController.swift
//  PocketKnockit
//
//  Created by Myles Scolnick on 12/24/14.
//  Copyright (c) 2014 WDMD. All rights reserved.
//

import UIKit

let DEBUG = true

class AddFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var addFriendTableView: UITableView!
    
    var testPeople = [NSString]()
    var testPeopleFiltered = [NSString]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(DEBUG){
            self.testPeople = ["Myles", "Weston", "David", "Dennis"]
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAddFriend(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(DEBUG){
            let cell = self.addFriendTableView.dequeueReusableCellWithIdentifier("AddFriendCell", forIndexPath: indexPath) as UITableViewCell
            
            var person:NSString
            if tableView == self.searchDisplayController!.searchResultsTableView {
                person = self.testPeopleFiltered[indexPath.row]
            } else {
                person = self.testPeople[indexPath.row]
            }
            
            // Configure the cell
            cell.textLabel.text = person
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            return cell
        }
        
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        var CellIdentifier:NSString = "AddFriendCell"
        var cell:UITableViewCell = self.addFriendTableView.dequeueReusableCellWithIdentifier(CellIdentifier) as UITableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (DEBUG){
            if tableView == self.searchDisplayController!.searchResultsTableView {
                return self.testPeopleFiltered.count
            }else{
                return self.testPeople.count
            }
        }
        
        return 0
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        if(DEBUG){
            self.testPeopleFiltered = self.testPeople.filter({(person: NSString) -> Bool in
                let stringMatch = person.rangeOfString(searchText)
                return (stringMatch.length != 0)
            })
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
}

