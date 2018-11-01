//
//  OverviewTableViewCell.swift
//  newsapp
//
//  Created by Ethan Winters on 10/24/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit

/*
 The table cell displyed on the user dash with the story title, categories, and thumbnail
 */
class OverviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(title: String, category: String, subcategory: String, thumbnailLink: String) {
        //Set label and cetegory
        titleLabel.text = title
        categoryLabel.text = category + ", " + subcategory
        let url = URL(string: thumbnailLink)
        //Asyncronously get the thumbnail url and update the actual thumbnail
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print (error)
                return
            }
            let myGroup = DispatchGroup()
            myGroup.enter()
            DispatchQueue.main.async {
                self.thumbnail.image = UIImage(data: data!)
            }
        }.resume()
    }

}
