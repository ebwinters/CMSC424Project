//
//  StoryTableViewCell.swift
//  newsapp
//
//  Created by Ethan Winters on 10/22/18.
//  Copyright © 2018 CMSC424IOS. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var messageView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(category: String, subcategory: String, message: String) {
        print (message)
        messageView.text = message
        categoryLabel.text = category + ", " + subcategory
    }

}
