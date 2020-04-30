//
//  ExercisesTableViewCell.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/28/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit



class ExercisesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var addSetButton: UIButton!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var RPELabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI(){
        
        
        
    }
    
    @IBAction func addSetClicked(_ sender: Any) {
        print("from cell")
        
    }
    

}
