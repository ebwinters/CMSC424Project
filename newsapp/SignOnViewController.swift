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
    var userSwitchOn = true
    var signInSwitchOn = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func userSwitchTapped(_ sender: Any) {
        userSwitchOn = !userSwitchOn
    }
    @IBAction func signInSwitchTapped(_ sender: Any) {
        signInSwitchOn = ! signInSwitchOn
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        print(emailField.text)
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
