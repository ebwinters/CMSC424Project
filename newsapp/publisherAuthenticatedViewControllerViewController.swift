//
//  publisherAuthenticatedViewControllerViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/10/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class publisherAuthenticatedViewControllerViewController: UIViewController {
    var publisherID = ""
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func deletePublisher(_ sender: Any) {
        if let users = Auth.auth().currentUser {
            users.delete { (error) in
                if error != nil {
                    print(error!)
                    return
                }
                try! Auth.auth().signOut()
                print("Publisher deleted")
                self.performSegue(withIdentifier: "deletedPublisher", sender: self)
                
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
