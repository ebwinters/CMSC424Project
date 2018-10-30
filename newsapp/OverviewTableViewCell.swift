//
//  OverviewTableViewCell.swift
//  newsapp
//
//  Created by Ethan Winters on 10/24/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(title: String, category: String, subcategory: String, thumbnailLink: String) {
        titleLabel.text = title
        categoryLabel.text = category + ", " + subcategory
        let url = URL(string: thumbnailLink)
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
