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
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
