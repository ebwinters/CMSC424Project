//
//  ImageCollectionViewController.swift
//  newsapp
//
//  Created by Ethan Winters on 10/28/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //imageCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        //Get image URL
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
    
    var images = NSDictionary()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }


}
