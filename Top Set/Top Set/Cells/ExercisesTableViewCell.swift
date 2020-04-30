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
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    
    @IBOutlet weak var addSetButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI(){
        let weightBottomLine = CALayer()
        weightBottomLine.frame = CGRect(x: 0.0, y: weightTextField.frame.height - 1, width: weightTextField.frame.width, height: 0.0)
        weightBottomLine.backgroundColor = UIColor.systemGreen.cgColor
        weightTextField.borderStyle = UITextField.BorderStyle.none
        weightTextField.layer.addSublayer(weightBottomLine)
        
        let repsBottomLine = CALayer()
        repsBottomLine.frame = CGRect(x: 0.0, y: repsTextField.frame.height - 1, width: weightTextField.frame.width, height: 0.0)
        repsBottomLine.backgroundColor = UIColor.systemGreen.cgColor
        repsTextField.borderStyle = UITextField.BorderStyle.none
        repsTextField.layer.addSublayer(repsBottomLine)
    }
    
    @IBAction func addSetClicked(_ sender: Any) {
        print("from cell")
        repsTextField.text = ""
        weightTextField.text = ""
    }
    

}
