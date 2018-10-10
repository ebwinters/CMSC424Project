//
//  ComposeViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/9/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ComposeViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPost(_ sender: Any) {
        //Post data to db realtime!
        ref.child("Posts").childByAutoId().setValue(textView.text)
        //IGNORE AND MOVE: ADDED A USER TO DATABASE
        Auth.auth().createUser(withEmail: "ebwinters@comcast.net", password: "ebWinters123!") { (user, error) in
            print(user?.user.email)
        }
        //Dismiss popover
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        //Sign user in, handle passing session details
        Auth.auth().signIn(withEmail: "ebwinters@comcast.net", password: "ebWinters123!") { (user, error) in
            if (user != nil) {
                print (user?.user.uid as? String)
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
