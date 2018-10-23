//
//  userAuthenticatedViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/10/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth

/*
 This class represents the view controller that is shown once a user has successfully signed in to the app
 The functions of this class are as follows:
 1. Ability to reemove a user and tranfer data to archive
 2. Set the user's current location, and if they choose not to, use the current location of the user
 3. Change subscription preferences for a user in terms of category subscriptions
 4. Retrieve stories near user's location and relay them to the current user based on their preferences
 */

class userAuthenticatedViewController: UIViewController {
    class Story : NSObject {
        var message: String
        var center: CLLocationCoordinate2D
        var category: String
        var subcategory: String
        var range: Double
        
        
        init(message: String, center: CLLocationCoordinate2D, category: String, subcategory: String, range: Double) {
            self.message = message
            self.center = center
            self.category = category
            self.subcategory = subcategory
            self.range = range
        }
    }
    
    var userID = ""    //Variable to keep track of signed in user's UID
    var currentLocation = CLLocationCoordinate2D()
    var ref:DatabaseReference!
    var subscriptions = [String]()
    var valid = [Story]()
    
    override func viewDidAppear(_ animated: Bool) {
        subscriptions = []
        valid = []
        self.getSubscriptions()
        self.getValidStories()
        
        print (userID, currentLocation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()       //Set Firebase reference to point to plist file
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showCategories") {
            let destinationVC = segue.destination as! CategoryViewController
            destinationVC.userID = sender as! String    //Send the user ID to the view controller
        }
        if (segue.identifier == "showStories") {
            let destinationVC = segue.destination as! StoryViewController
            destinationVC.userID = sender as! String    //Send the user ID to the view controller
            destinationVC.currentLocation = currentLocation
            destinationVC.subscriptions = self.subscriptions
            destinationVC.validStories = self.valid
        }
        if segue.identifier == "updateLocation" {
            let destinationVC = segue.destination as! LocationChangeViewController
            destinationVC.userID = userID
        }
    }
    
    /*
     Action outlet to segue to category select controller with UID to save subscription data
     */
    @IBAction func subscriptionPreferences(_ sender: Any) {
        performSegue(withIdentifier: "showCategories", sender: userID)
    }
    
    @IBAction func getStories(_ sender: Any) {
        performSegue(withIdentifier: "showStories", sender: userID)
    }
    
    
    @IBAction func changeLocationPress(_ sender: Any) {
        performSegue(withIdentifier: "updateLocation", sender: (Any).self)
    }
    
    
    /*
     Action outlet to delete current user when pressed, and move to archived users
     */
    @IBAction func deleteCurrentUser(_ sender: Any) {
        if let users = Auth.auth().currentUser {        //Grab current signed in user
            ref.child("Users").child(users.uid).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary     //Grab all user data
                self.ref.child("oldUsers").child(users.uid).setValue(value)     //Add to archived users
                self.ref.child("Users").child(users.uid).removeValue()      //Remove from active users
            }
            users.delete { (error) in
                if error != nil {
                    print(error!)
                    return
                }
                try! Auth.auth().signOut()
                print("User deleted")
                self.performSegue(withIdentifier: "deletedUser", sender: self)      //Send back to login screen
            }
        }
    }
    
    func isInRegion (region : MKCoordinateRegion, coordinate : CLLocationCoordinate2D) -> Bool {
        
        let center   = region.center;
        let northWestCorner = CLLocationCoordinate2D(latitude: center.latitude  - (region.span.latitudeDelta  / 2.0), longitude: center.longitude - (region.span.longitudeDelta / 2.0))
        let southEastCorner = CLLocationCoordinate2D(latitude: center.latitude  + (region.span.latitudeDelta  / 2.0), longitude: center.longitude + (region.span.longitudeDelta / 2.0))
        
        return (
            coordinate.latitude  >= northWestCorner.latitude &&
                coordinate.latitude  <= southEastCorner.latitude &&
                
                coordinate.longitude >= northWestCorner.longitude &&
                coordinate.longitude <= southEastCorner.longitude
        )
    }
    
    public func getValidStories() {
        ref.child("News").observeSingleEvent(of: .value) { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let entry = rest.value as! NSDictionary
                let lat = ((entry["center"] as! NSDictionary)["latitude"] as! String).toDouble()
                let long = ((entry["center"] as! NSDictionary)["longitude"] as! String).toDouble()
                let center = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                let rangeMiles = entry["range"] as! Double
                let rangeMeters = rangeMiles * 1609.344
                let region = MKCoordinateRegion(center: center, latitudinalMeters: rangeMeters, longitudinalMeters: rangeMeters)
                if self.isInRegion(region: region, coordinate: self.currentLocation) {
                    if self.subscriptions.contains(entry["category"] as! String) || self.subscriptions.contains(entry["subcategory"] as! String) {
                        self.valid.append(Story(message: entry["message"] as! String, center: center, category: entry["category"] as! String, subcategory: entry["subcategory"] as! String, range: rangeMiles))
                    }
                }
            }
        }
    }
    
    public func getSubscriptions() {
        ref.child("Subscribes").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                self.subscriptions.append(rest.value as! String)     //Get all current user subscriptions
            }
        }
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
