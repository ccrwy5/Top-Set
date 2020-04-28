//
//  OneRepMaxViewController.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit

class OneRepMaxViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var calculateButton: UIButton!
    var unit: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        unit = unitsSegmentedControl.titleForSegment(at: unitsSegmentedControl.selectedSegmentIndex)!
        weightTextField.placeholder = unit
        weightTextField.delegate = self
        repsTextField.delegate = self
        
        setupUI()

    }
    
    @IBAction func calculateButtonPressed(_ sender: Any) {
        guard let weightText = weightTextField.text else { return }
        guard let repsText = repsTextField.text else { return }
        

        let weightFilter = weightText.filter("0123456789.".contains)

        let reps = Double(repsText)
        let weight = Double(weightFilter)
        
        let ORM = weight! * (1 + (reps!/30))
        let roundedORM = round(ORM)
        
        Alert.oneRepMaxFound(on: self, result: roundedORM, units: unit.lowercased())
        
        

    }
    
    
    @IBAction func unitsSwitched(_ sender: Any) {
        
        if unitsSegmentedControl.selectedSegmentIndex == 0 {
            unit = unitsSegmentedControl.titleForSegment(at: unitsSegmentedControl.selectedSegmentIndex)!
            
        } else if unitsSegmentedControl.selectedSegmentIndex == 1 {
            unit = unitsSegmentedControl.titleForSegment(at: unitsSegmentedControl.selectedSegmentIndex)!
            
        }
        
        weightTextField.placeholder = unit
    }
    
    func setupUI(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.alpha = 0.3;
        topImageView.addSubview(blurEffectView)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: weightTextField.frame.height - 1, width: weightTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.systemGreen.cgColor
        weightTextField.borderStyle = UITextField.BorderStyle.none
        weightTextField.layer.addSublayer(bottomLine)

        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: repsTextField.frame.height - 1, width: repsTextField.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor.systemGreen.cgColor
        repsTextField.borderStyle = UITextField.BorderStyle.none
        repsTextField.layer.addSublayer(bottomLine2)
        
        calculateButton.layer.cornerRadius = 10
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == weightTextField {
            if unit == "Pounds" {
                weightTextField.text = weightTextField.text! + " lbs"
            } else if unit == "Kilograms" {
                    weightTextField.text = weightTextField.text! + " kgs"
            }
        }
    }
    
    
    


}
