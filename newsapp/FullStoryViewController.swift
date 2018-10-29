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
    //Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageView: UITextView!
    
    
    var userID = ""
    var currentLocation = CLLocationCoordinate2D()
    var story = userAuthenticatedViewController.Story(title: "", pubName: "", message: "", center: CLLocationCoordinate2D(), category: "", subcategory: "", range: 0.0, imageURL: "", images: NSDictionary())
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        performSegue(withIdentifier: "showImages", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showImages") {
            let destinationVC = segue.destination as! ImageCollectionViewController
            var imageDictionary = [String:String]()
            for (index, image) in story.images.enumerated() {
                var stringValue = "\(index)"
                imageDictionary[stringValue] = image.value as! String
            }
            
            destinationVC.images = imageDictionary as NSDictionary
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up imageView gesture handler
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.navigationController?.isNavigationBarHidden = false
        
        titleLabel.text = story.title
        nameLabel.text = "Written by: \n" + story.pubName
        nameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        nameLabel.numberOfLines = 0;
        nameLabel.sizeToFit()
        categoryLabel.text = story.category + ", " + story.subcategory
        messageView.text = story.message
        let url = URL(string: story.imageURL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print (error)
                return
            }
            let myGroup = DispatchGroup()
            myGroup.enter()
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }.resume()

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
