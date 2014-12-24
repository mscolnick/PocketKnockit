//
//  ContactTableViewCell.swift
//  PocketKnockit
//
//  Created by Myles Scolnick on 12/23/14.
//  Copyright (c) 2014 WDMD. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberField: UITextField!
    
    var vibrationCount:NSInteger = 0
    var idForCell:NSString = ""
    var userName:NSString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func textFieldShouldReturn(aTextField: UITextField) -> Bool {
        self.numberField.resignFirstResponder()
        return true
    }
    
    @IBAction func editingChanged(sender: AnyObject) {
        var def:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        def.setInteger(self.numberField.text.toInt()!, forKey: self.idForCell)
        def.synchronize()
    }    
        // Configure the view for the selected state
    
}