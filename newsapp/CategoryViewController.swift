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
    var categoryData = [(String, Bool)]()
    var userID = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! MainCategoryTableViewCell
        cell.configure(category: categoryData[indexPath.row].0, isSubscribed: categoryData[indexPath.row].1, userID: userID)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //Set Firebase reference
        ref = Database.database().reference()
        
        var subscriptions = [String]()
        ref.child("Subscribes").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                subscriptions.append(rest.value as! String)
            }
        }
        ref.child("Categories").observeSingleEvent(of: .value) { snapshot in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let temp_key = rest.key
                let subscribed = subscriptions.contains(temp_key)
                self.categoryData.append((temp_key, subscribed))
            }
            self.tableView.reloadData()
        }
    }

}
