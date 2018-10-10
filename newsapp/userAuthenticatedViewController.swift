//
//  userAuthenticatedViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/10/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class userAuthenticatedViewController: UIViewController {
    var userID = ""
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print (self.userID)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteCurrentUser(_ sender: Any) {
        if let users = Auth.auth().currentUser {
            users.delete { (error) in
                if error != nil {
                    print(error!)
                    return
                }
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
