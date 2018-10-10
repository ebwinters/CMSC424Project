//
//  ViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/9/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle = 0
    
    var postData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set Firebase reference
        ref = Database.database().reference()
        
        //Retrieve posts, listen for changes
        //Note--function .observe returns a UINT (ref to listener)
        databaseHandle = ref.child("Posts").observe(.childAdded) { (snapshot) in
            //Code below executes for children under Posts
            //Value from snapshot --> postData
            let post = snapshot.value as? String
            if let actualPost = post {
                self.postData.append(actualPost)
                //Reload tableView to reflect changes
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell")
        cell?.textLabel?.text = postData[indexPath.row]
        return cell!
    }


}

