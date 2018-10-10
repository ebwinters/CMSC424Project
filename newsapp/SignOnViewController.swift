//
//  SignOnViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/10/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignOnViewController: UIViewController {
    @IBOutlet weak var userPublisherSwitch: UISegmentedControl!
    @IBOutlet weak var signInSwitch: UISegmentedControl!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    var userSwitchOn = true
    var signInSwitchOn = true
    
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        self.finishButton.layer.borderWidth = 1.0
        self.finishButton.layer.borderColor = UIColor.black.cgColor
        self.finishButton.layer.cornerRadius = 3.0
    }
    
    
    @IBAction func userSwitchTapped(_ sender: Any) {
        userSwitchOn = !userSwitchOn
    }
    @IBAction func signInSwitchTapped(_ sender: Any) {
        signInSwitchOn = !signInSwitchOn
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        //Case 1: Register new user
        if userSwitchOn == true && signInSwitchOn == false {
            //Sanitize
            if isValidEmail(testStr: emailField.text!) {
                Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                    user?.user.sendEmailVerification(completion: { (error) in
                        //Add user to users table and tell user to check email
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
                        //Add user to publishers table and tell user to check email
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
    //Function to verify if an email address is valid
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
