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
    var userID = ""    //Variable to ekep track of signed in user's UID
    var currentLocation = CLLocationCoordinate2D()
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()       //Set Firebase reference to point to plist file
        print (currentLocation)
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
}
