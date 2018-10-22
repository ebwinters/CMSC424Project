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
    var hidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        self.navigationController?.isNavigationBarHidden = hidden

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "publishStory" {
            let destinationVC = segue.destination as! NewStoryViewController
            destinationVC.publisherID = sender as! String    //Send the user ID to the view controller
        }
    }
    
    
    @IBAction func showPublishStory(_ sender: Any) {
        performSegue(withIdentifier: "publishStory", sender: publisherID)
    }
    
    @IBAction func deletePublisher(_ sender: Any) {
        if let users = Auth.auth().currentUser {
            ref.child("Publishers").child(users.uid).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                //Add to archive table
                self.ref.child("oldPublishers").child(users.uid).setValue(value)
                print (value)
                //Remove from current user table
                self.ref.child("Publishers").child(users.uid).removeValue()
            }
            users.delete { (error) in
                if error != nil {
                    print(error!)
                    return
                }
                //Delete user from auth table
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
