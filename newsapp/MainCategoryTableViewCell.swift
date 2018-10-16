//
//  MainCategoryTableViewCell.swift
//  newsapp
//
//  Created by Ethan Winters on 10/15/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit

class MainCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(category: String, isSubscribed: Bool) {
        categoryLabel.text = category
        categorySwitch.setOn(isSubscribed, animated: false)
    }

}
