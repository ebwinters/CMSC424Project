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
        return cell
    }
    
    
    var userID = ""
    var subscriptions = [String]()   //Passed in from previous controller, a list of all subscriptions to categories/subcategories that the current user has
    var currentLocation = CLLocationCoordinate2D()
    var validStories = NSDictionary()
    var ref = Database.database().reference()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print (userID)
        print (currentLocation)
        print (subscriptions)
        //For each entry in stories
            //Get lat long make center
            //Convert range to miles
            //MKCoordinateRegion(center: <#T##CLLocationCoordinate2D#>, latitudinalMeters: <#T##CLLocationDistance#>, longitudinalMeters: <#T##CLLocationDistance#>)
            //Check if user location in region
                //Check is category or subcategory in subscriptions
                    //Make cell with story
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
