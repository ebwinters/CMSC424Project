//
//  ImageCollectionViewCell.swift
//  newsapp
//
//  Created by Ethan Winters on 10/28/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    public func configure(data: Data) {
        self.imageView.image = UIImage(data: data)
    }
}
