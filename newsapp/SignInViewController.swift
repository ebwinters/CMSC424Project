//
//  SignInViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/9/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    @IBOutlet weak var signInSelector: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: "ebw", password: "ebw123!") { (authResult, error) in
            // ...
            guard let user = authResult?.user else { return }
        }
        //Form validation done here
        
//        if let email = emailTextField.text, let password = passwordTextField.text {
//            if isSignIn {
//                print ("IS SIGN IN")
//                print (email + " " + password)
//                //Sign in user
//                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//                    if let u = user?.user {
//                        //User valid, send to next screen
//                        self.performSegue(withIdentifier: "goToHome", sender: self)
//                    }
//                    else {
//                        //Error
//                    }
//                }
//            }
//            else {
//                print (email + " " + password)
//                //Register user
//                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//                    if let u = user?.user {
//                        //User valid, go to next screen
//                        self.performSegue(withIdentifier: "goToHome", sender: self)
//                    }
//                    else {
//                        //Error
//                    }
//                }
//            }
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
