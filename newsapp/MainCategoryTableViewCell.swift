//
//  MainCategoryTableViewCell.swift
//  newsapp
//
//  Created by Ethan Winters on 10/15/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import Firebase

class MainCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!
    var userID = ""
    var ref = Database.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
     Configure a cell with category title and a boolean to hold is user has subsribed or not, to preset the switch to on or off
     */
    public func configure(category: String, isSubscribed: Bool, userID: String) {
        categoryLabel.text = category
        categorySwitch.setOn(isSubscribed, animated: false)
        self.userID = userID
    }
    
    @IBAction func categoryToggle(_ sender: Any) {
        let category = categoryLabel.text       //Get category for cell
        categorySwitch.setOn(categorySwitch.isOn, animated: false)      //Flip switch value
        //Set user subscription value in Firebase
        //Case 1: User flips switch off - remove from subscriptions
        if categorySwitch.isOn == false {
            ref.child("Subscribes").child(userID).observeSingleEvent(of: .value) { (snapshot) in
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    if rest.value as! String == category {
                        self.ref.child("Subscribes").child(self.userID).child(rest.key).removeValue { (error, ref) in
                            if error != nil {
                                print("error \(error)")
                            }
                        }
                    }
                }
            }
        }
        //Case 2: User flips switch on - add to subscriptions
        else {
            self.ref.child("Subscribes").child(userID).childByAutoId().setValue(category)     //Add new category subscription for user with userID
        }
    }
    
    
    
    

}
