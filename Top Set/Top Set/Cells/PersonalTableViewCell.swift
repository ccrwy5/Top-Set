//
//  PersonalTableViewCell.swift
//  Top Set
//
//  Created by Chris Rehagen on 5/1/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit

class PersonalTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyPartLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
