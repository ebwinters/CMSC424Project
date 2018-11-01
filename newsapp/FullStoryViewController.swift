//
//  FullStoryViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/25/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit
import MapKit

/*
 Controller to present a story to the user
 */
class FullStoryViewController: UIViewController {
    //Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageView: UITextView!
    
    
    var userID = ""
    var currentLocation = CLLocationCoordinate2D()
    var story = userAuthenticatedViewController.Story(title: "", pubName: "", message: "", center: CLLocationCoordinate2D(), category: "", subcategory: "", range: 0.0, imageURL: "", images: NSDictionary())   //Holds data on story we are trying to present
    
    /*
     When image tapped, take the user to collectionView of images
     */
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
            
            destinationVC.images = imageDictionary as NSDictionary      //Send indexed dict of urls
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up imageView gesture handler
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.navigationController?.isNavigationBarHidden = false
        
        //Set labels correctly for story title, text, etc
        titleLabel.text = story.title
        nameLabel.text = "Written by: \n" + story.pubName
        nameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        nameLabel.numberOfLines = 0;
        nameLabel.sizeToFit()
        categoryLabel.text = story.category + ", " + story.subcategory
        messageView.text = story.message
        let url = URL(string: story.imageURL)
        //Asyncronously get the image url and update the imageView
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
    }
}
