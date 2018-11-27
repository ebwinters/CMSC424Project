//
//  SignOnViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/10/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth

class SignOnViewController: UIViewController, CLLocationManagerDelegate {
    //Outlets for physical components
    @IBOutlet weak var userPublisherSwitch: UISegmentedControl!
    @IBOutlet weak var signInSwitch: UISegmentedControl!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    //Outlets for toggled fields - to be displayed conditionally
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    //Create switches to se weather signing in user/publisher or registering
    var userSwitchOn = true
    var signInSwitchOn = true
    
    //Set up location manager
    var locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    
    var ref:DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        ref = Database.database().reference()       //Add Firebase DB reference
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()     //Call locationDidUpdate
        }
        
        
        //Set some UI attributes
        self.finishButton.layer.borderWidth = 1.0
        self.finishButton.layer.borderColor = UIColor.white.cgColor
        self.finishButton.layer.cornerRadius = 3.0
        
        //Toggle labels and fields
        self.nameLabel.isHidden = true
        self.nameField.isHidden = true
        self.addressLabel.isHidden = true
        self.addressField.isHidden = true
    }
    
    /*
     Function to prepare the segue to a publisher or user portal, sending respective information to either view
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showUserAuth") {       //User signed in successfully
            let destinationVC = segue.destination as! userAuthenticatedViewController
            destinationVC.userID = sender as! String    //Send the user ID to the view controller
            destinationVC.currentLocation = currentLocation     //Send the user location to the view controller
        }
        else if (segue.identifier == "showPublisherAuth") {     //Publisher signed in successfully
            let destinationVC = segue.destination as! publisherAuthenticatedViewControllerViewController
            destinationVC.publisherID = sender as! String       //Send the publisher ID to the view controller
        }
    }
    
    /*
     When switched between user and publisher, adjust flag to note which is programatically selected
     */
    @IBAction func userSwitchTapped(_ sender: Any) {
        userSwitchOn = !userSwitchOn
    }
    
    /*
     When switched between sign in and register, adjust flag to note which is programatically selected. If we are registering, show name and address fields
     */
    @IBAction func signInSwitchTapped(_ sender: Any) {
        signInSwitchOn = !signInSwitchOn
        if signInSwitchOn == true {
            self.nameLabel.isHidden = true
            self.nameField.isHidden = true
            self.addressLabel.isHidden = true
            self.addressField.isHidden = true
        }
        else {
            self.nameLabel.isHidden = false
            self.nameField.isHidden = false
            self.addressLabel.isHidden = false
            self.addressField.isHidden = false
        }
    }
    
    /*
     Action outlet to handle the sign in/register process being completed. This function covers all 4 cases or registering a user/publisher or signing in a user/publisher
     */
    @IBAction func finishButtonTapped(_ sender: Any) {
        //Case 1: Register new user
        if userSwitchOn == true && signInSwitchOn == false {
            if isValidEmail(testStr: emailField.text!) {        //Sanitize email
                Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                    user?.user.sendEmailVerification(completion: { (error) in
                       let post = [
                        "email": user?.user.email,
                        "name": self.nameField.text!,
                        "address": self.addressField.text!
                        ]
                        self.ref.child("Users").child((user?.user.uid)!).setValue(post)     //Add to users under UID
                        self.warningLabel.textColor = UIColor.green
                        self.warningLabel.text = "Check email for verification"
                    })
                }
            }
            else {
                //Update a label to say check valid credentials
                self.warningLabel.text = "Check that email is valid"
            }
        }
        //Case 2: Register new publisher
        if userSwitchOn == false && signInSwitchOn == false {
            //Sanitize
            if isValidEmail(testStr: emailField.text!) {
                Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                    user?.user.sendEmailVerification(completion: { (error) in
                        let post = [
                            "email": user?.user.email,
                            "name": self.nameField.text!,
                            "address": self.addressField.text!
                        ]
                        self.ref.child("Publishers").child((user?.user.uid)!).setValue(post)
                        self.warningLabel.textColor = UIColor.green
                        self.warningLabel.text = "Check email for verification"
                    })
                }
            }
            else {
                //Update a label to say check valid credentials
                self.warningLabel.text = "Check that email is valid"
            }
        }
        //Case 3: Sign in user
        if userSwitchOn == true && signInSwitchOn == true {
            //Make sure email verified
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if user != nil {
                    if user!.user.isEmailVerified{
                        self.warningLabel.textColor = UIColor.green
                        self.warningLabel.text = "You're In!"
                        //Segue to user dash /w credentials passed
                        self.ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.hasChild((user?.user.uid)!) {
                                self.performSegue(withIdentifier: "showUserAuth", sender: user?.user.uid)
                            }
                            else {
                                self.warningLabel.textColor = UIColor.red
                                self.warningLabel.text = "Invalid user"
                            }
                        })
                    }
                    else {
                        self.warningLabel.text = "Verify your email"
                    }
                }
                else {
                    self.warningLabel.text = "Invalid user"
                }
            }
        }
        //Case 4: Sign in publisher
        if userSwitchOn == false && signInSwitchOn == true {
            //Make sure email verified
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if user != nil {
                    if user!.user.isEmailVerified{
                        self.warningLabel.textColor = UIColor.green
                        self.warningLabel.text = "You're In!"
                        //Segue to publisher dash /w credentials passed
                        self.ref.child("Publishers").observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.hasChild((user?.user.uid)!) {
                                self.performSegue(withIdentifier: "showPublisherAuth", sender: user?.user.uid)
                            }
                            else {
                                self.warningLabel.textColor = UIColor.red
                                self.warningLabel.text = "Invalid publisher"
                            }
                        })
                    }
                    else {
                        //Update label to say "verify email"
                        self.warningLabel.text = "Verify your email"
                    }
                }
                else {
                    self.warningLabel.text = "Invalid user"
                }
            }
        }
    }
    
    //Helper functions
    /*
     Function to verify if an email address is valid or not using Regex
     */
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /*
     Helper function to set current location to current user location
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
}
