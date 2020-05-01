//
//  GoalTableViewCell.swift
//  Top Set
//
//  Created by Chris Rehagen on 5/1/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var goalTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
