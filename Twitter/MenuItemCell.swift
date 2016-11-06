//
//  MenuItemCell.swift
//  Twitter
//
//  Created by Carina Boo on 11/5/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
