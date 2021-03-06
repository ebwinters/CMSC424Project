//
//  CategoryViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/15/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var ref:DatabaseReference!
    var categoryData = [(String, Bool)]()       //Will hold all categories for user and if they are subscribed or not
    var userID = ""
    
    /*
     Return amount of items in tableView
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    /*
     Create cell in tableview using cutsom MainCategoryTableViewCell class
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! MainCategoryTableViewCell
        cell.configure(category: categoryData[indexPath.row].0, isSubscribed: categoryData[indexPath.row].1, userID: userID)        //Configure cell using the correct category, if the user is subscribed, and also pass in the userID to be used onToggle for the UISwitch
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryData[indexPath.row].0        //Category for cell
        var subscriptions = [String]()      //List to hold all categories user subscribes to
        ref.child("Subscribes").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                subscriptions.append(rest.value as! String)     //Get all current user subscriptions
            }
        }
        //Get user data for subcategories
        var subcategoryData = [(String, Bool)]()        //Data to be passed into subCategoryViewController
        ref = Database.database().reference()
        ref.child("Categories").observeSingleEvent(of: .value) { snapshot in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let temp_key = rest.key     //Get all category names
                if category == rest.key {       //If this is the one we clicked
                    let children = rest.value as! NSDictionary       //Get all subcategories
                    for child in children {
                        if child.value as! String != "None" {
                            let subscribed = subscriptions.contains(child.value as! String)
                            subcategoryData.append((child.value as! String, subscribed))      //If already subscribed, let the next view controller know
                        }
                    }
                }
            }
            self.performSegue(withIdentifier: "showSubcategories", sender: (self.userID, subcategoryData))
        }
    }
    
    /*
     Go to the subcategoryViewController passing in UID and data on user subscriptions to subcategories
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showSubcategories") {       //User signed in successfully
            let destinationVC = segue.destination as!   SubcategoryViewController
            destinationVC.subcategoryData = sender as! (String, [(String, Bool)])     //Send the user location to the view controller
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false

        tableView.delegate = self
        tableView.dataSource = self
        
        //Set Firebase reference
        ref = Database.database().reference()
        
        var subscriptions = [String]()      //List to hold all categories user subscribes to
        ref.child("Subscribes").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                subscriptions.append(rest.value as! String)
            }
        }
        
        ref.child("Categories").observeSingleEvent(of: .value) { snapshot in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let temp_key = rest.key     //Get all category names
                let subscribed = subscriptions.contains(temp_key)       //See if user is subscribed
                self.categoryData.append((temp_key, subscribed))        //If user is subscribed append (categoryName,true), otherwise (categoryName,false) to display correct data when user loads category selection screen
            }
            self.tableView.reloadData()
        }
    }

}
