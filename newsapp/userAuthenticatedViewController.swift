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

class userAuthenticatedViewController: UIViewController, CLLocationManagerDelegate {
    var userID = ""
    var ref:DatabaseReference!
    var locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            if locationManager.location?.coordinate == nil {
                locationManager.requestLocation()
            }
            currentLocation = (locationManager.location?.coordinate)!
        }
    }
    
    @IBAction func deleteCurrentUser(_ sender: Any) {
        if let users = Auth.auth().currentUser {
            ref.child("Users").child(users.uid).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                //Add to archive table
                self.ref.child("oldUsers").child(users.uid).setValue(value)
                print (value)
                //Remove from current user table
                self.ref.child("Users").child(users.uid).removeValue()
            }
            users.delete { (error) in
                if error != nil {
                    print(error!)
                    return
                }
                //Delete user from auth table
                try! Auth.auth().signOut()
                print("User deleted")
                self.performSegue(withIdentifier: "deletedUser", sender: self)
            }
        }
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
