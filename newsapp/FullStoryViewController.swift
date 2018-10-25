//
//  FullStoryViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/25/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import MapKit

class FullStoryViewController: UIViewController {
    
    var userID = ""
    var currentLocation = CLLocationCoordinate2D()
    var story = userAuthenticatedViewController.Story(title: "", pubName: "", message: "", center: CLLocationCoordinate2D(), category: "", subcategory: "", range: 0.0, imageURL: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
