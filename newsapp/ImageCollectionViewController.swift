//
//  ImageCollectionViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/28/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit

/*
 View controller to display a collection view of images for a specific story
 */
class ImageCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        //Set some UI prefs
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        //Get image URL async
        let indexPathString = "\(indexPath.row)"
        let url = URL(string: (images.value(forKey: indexPathString) as! String))
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print (error)
                return
            }
            let myGroup = DispatchGroup()
            myGroup.enter()
            DispatchQueue.main.async {
                cell.configure(data: data!)
            }
        }.resume()
        return cell
    }
    
    var images = NSDictionary()     //Dict: 0->"http..."
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        //Set collection view delegates
        collectionView.dataSource = self
        collectionView.delegate = self
    }


}
