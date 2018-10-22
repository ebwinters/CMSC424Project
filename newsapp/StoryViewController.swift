//
//  StoryViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/22/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class StoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return validStories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell") as! StoryTableViewCell
        cell.configure(category: validStories[indexPath.row].category, subcategory: validStories[indexPath.row].subcategory, message: validStories[indexPath.row].message)
        return cell
    }
    
    
    var userID = ""
    var subscriptions = [String]()   //Passed in from previous controller, a list of all subscriptions to categories/subcategories that the current user has
    var currentLocation = CLLocationCoordinate2D()
    var validStories = [userAuthenticatedViewController.Story]()
    var ref = Database.database().reference()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print (userID)
        print (currentLocation)
        print (subscriptions)
        for item in validStories {
            print (item)
        }
    }
}
