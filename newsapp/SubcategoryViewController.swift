//
//  SubcategoryViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/16/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SubcategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var ref:DatabaseReference!
    var subcategoryData = ("", [("",false)])
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategoryData.1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! SubCategoryTableViewCell
        cell.configure(category: subcategoryData.1[indexPath.row].0, isSubscribed: subcategoryData.1[indexPath.row].1, userID: subcategoryData.0)        //Configure cell using the correct subcategory, if the user is subscribed, and also pass in the userID to be used onToggle for the UISwitch
        return cell
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set Firebase reference
        ref = Database.database().reference()

        var subscriptions = [String]()      //List to hold all subcategories user subscribes to
        ref.child("Subscribes").child(subcategoryData.0).observeSingleEvent(of: .value) { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                subscriptions.append(rest.value as! String)
            }
        }
    }
}
