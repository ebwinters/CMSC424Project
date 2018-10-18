//
//  MainCategoryTableViewCell.swift
//  newsapp
//
//  Created by Ethan Winters on 10/15/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import Firebase

/*
 Custom category cell class
 */
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
    }
    
    /*
     Configure a cell with category title and a boolean to hold is user has subsribed or not, to preset the switch to on or off
     */
    public func configure(category: String, isSubscribed: Bool, userID: String) {
        categoryLabel.text = category
        categorySwitch.setOn(isSubscribed, animated: false)     //Set switch on if user already subscribed
        self.userID = userID
    }
    
    @IBAction func categoryToggle(_ sender: Any) {
        let category = categoryLabel.text       //Get category for cell
        var subscriptions = [String]()      //List to hold all categories user subscribes to
        ref.child("Subscribes").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                subscriptions.append(rest.value as! String)     //Fill subscription list
            }
        }
        
        categorySwitch.setOn(categorySwitch.isOn, animated: false)      //Flip switch value
        //Set user subscription value in Firebase
        //Case 1: User flips switch off - remove from subscriptions, remove all subcategory subscriptions
        if categorySwitch.isOn == false {
            ref.child("Subscribes").child(userID).observeSingleEvent(of: .value) { (snapshot) in
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    if rest.value as! String == category {      //See if this is the category that the user is trying to unsubscribe to
                        self.ref.child("Subscribes").child(self.userID).child(rest.key).removeValue { (error, ref) in       //If it is, remove the subscription for the user to the category
                            if error != nil {
                                print("error \(error)")
                            }
                        }
                    }
                }
            }
            //Remove apporopriate subcategories from subscription list for user
            ref.child("Categories").observeSingleEvent(of: .value) { snapshot in
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    let temp_key = rest.key     //Get all category names
                    if category == rest.key {       //If this is the one we clicked
                        let children = rest.children.allObjects as! [DataSnapshot]       //Get all subcategories for category we clicked switch for
                        for child in children {
                            let subscribed = subscriptions.contains(child.value as! String)     //Is user subscribed?
                            if subscribed {
                                self.ref.child("Subscribes").child(self.userID).observeSingleEvent(of: .value) { (snapshot) in
                                    for rest2 in snapshot.children.allObjects as! [DataSnapshot] {
                                        if child.value as! String == rest2.value as! String {   //Find key value pair for subscription with correct subcategory subscription to remove
                                            self.ref.child("Subscribes").child(self.userID).child(rest2.key).removeValue { (error, ref) in       //Remove the subscription for the user to the subcategory
                                                if error != nil {
                                                    print("error \(error)")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        //Case 2: User flips switch on - add to subscriptions, add all subcategories to subscriptions
        else {
           //Add new category subscription for user with userID
            self.ref.child("Subscribes").child(userID).childByAutoId().setValue(category)
            //Suscribe to all subcategories
            var subcategoryData = [(String, Bool)]()
            //Check if user is subscribed to the subcategories
            ref.child("Categories").observeSingleEvent(of: .value) { snapshot in
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    let temp_key = rest.key     //Get all category names
                    if category == rest.key {
                        let children = rest.value as! NSArray
                        for child in children {
                            let subscribed = subscriptions.contains(child as! String)
                            subcategoryData.append((child as! String, subscribed))
                        }
                    }
                }
                for dataItem in subcategoryData {
                    if dataItem.1 == false {        //If user not subscribed to subcategory, subscribe them
                        self.ref.child("Subscribes").child(self.userID).childByAutoId().setValue(dataItem.0)
                    }
                }
            }
        }
    }
}
