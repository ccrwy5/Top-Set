//
//  NewWorkoutViewController.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit
import Firebase
import TinyConstraints
import KMPlaceholderTextView




class NewWorkoutViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {

    

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var bodyPartTextField: UITextField!
    
    let dateFormatter = DateFormatter()

    
    let postRef = Database.database().reference().child("posts").childByAutoId()
    
    lazy var textView: KMPlaceholderTextView = {
        let tv = KMPlaceholderTextView()
        tv.layer.cornerRadius = 8
        tv.layer.borderWidth = 1.0
        tv.layer.borderColor = UIColor.systemGreen.cgColor
        tv.placeholder = "Enter details here"
        return tv
    }()
    
    let muscleGroups = ["Chest", "Back", "Legs", "Abs", "Arms", "Triceps", "Biceps", "Shoulders", "Chest + Triceps", "Back + Biceps", "Upper Body", "Lower Body"]
    let musclePicker = UIPickerView()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textView)
        textView.topToBottom(of: bodyPartTextField, offset: 30)
        textView.leftToSuperview(offset: 40, usingSafeArea: true)
        textView.rightToSuperview(offset: -40, usingSafeArea: true)
        textView.height(250)
        
        
        musclePicker.delegate = self
        bodyPartTextField.inputView = musclePicker


        titleTextField.delegate = self
        dateTextField.delegate = self
        bodyPartTextField.delegate = self
        
        postButton.isEnabled = false
        postButton.alpha = 0.5
        [titleTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
//        [dateTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
//        [bodyPartTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })


        setupUI()
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(NewWorkoutViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        
        dateTextField.inputView = datePicker
        
    }
        
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let title = titleTextField.text, !title.isEmpty
        else {
            self.postButton.isEnabled = false
            postButton.alpha = 0.5
            return
        }
        postButton.isEnabled = true
        postButton.alpha = 1.0
        
//        guard
//            let date = dateTextField.text, !date.isEmpty
//        else {
//            self.postButton.isEnabled = false
//            postButton.alpha = 0.5
//            return
//        }
//        postButton.isEnabled = true
//        postButton.alpha = 1.0
//
//        guard
//            let bodyPart = bodyPartTextField.text, !bodyPart.isEmpty
//        else {
//            self.postButton.isEnabled = false
//            postButton.alpha = 0.5
//            return
//        }
//        postButton.isEnabled = true
//        postButton.alpha = 1.0
    }
    
    @IBAction func handlePostButton(_ sender: Any) {
        
        
        guard let userProfile = UserService.currentUserProfile else {
            print("error in userProfile")
            return
        }
        guard let title = titleTextField.text else { return }
        guard let workoutDate = dateTextField.text else { return }
        guard let details = textView.text else { return }
        guard let bodyPart = bodyPartTextField.text else { return }

        if title == "" {
            Alert.showInCompleteFormAlert(on: self)
            return
        }

//        if title == "" {
//            Alert.showInCompleteFormAlert(on: self)
//        } else {
            let postObject = [
                "author": [
                    "uid": userProfile.uid,
                    "username": userProfile.username,
                    "photoURL": userProfile.photoURL.absoluteString,
                    "email": userProfile.email,
                    "fullName": userProfile.fullName
                ],
                "timestamp": [".sv":"timestamp"],
                "postID": postRef.key!,
                "title": title,
                "workoutDate": workoutDate,
                "bodyPart": bodyPart,
                "details": details
            ] as [String:Any]

            postRef.setValue(postObject, withCompletionBlock: { error, ref in
                if error == nil {

                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("error in postRef setValue")
                }
            })

            print("4")
            let currentUser = (Auth.auth().currentUser?.uid)!
            let personalFeedRef = Database.database().reference().child("users").child("profile").child(currentUser).child("User's Workouts").childByAutoId()
            let listingObject = [
                "personal_feed_id": personalFeedRef.key!,
                "main_feed_id": postRef.key!,
                "title": title,
                "workoutDate": workoutDate,
                "details": details,
                "bodyPart": bodyPart
            ] as [String: Any]

            personalFeedRef.updateChildValues(listingObject) { (error, ref) in
                if error == nil{
                    print("done 2")
                }
            }
        //}
        
        switchToDataTabCont()
        
    }
    
    func switchToDataTab() {
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(switchToDataTabCont), userInfo: nil, repeats: false)
    }

    @objc func switchToDataTabCont(){
        tabBarController!.selectedIndex = 0
    }

    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: sender.date)
        dateTextField.text = strDate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    /* ---------- UI Adjustments ---------- */

    func setupUI(){
        let titleButtonLine = CALayer()
        titleButtonLine.frame = CGRect(x: 0.0, y: titleTextField.frame.height - 1, width: titleTextField.frame.width, height: 1.0)
        titleButtonLine.backgroundColor = UIColor.systemGreen.cgColor
        titleTextField.borderStyle = UITextField.BorderStyle.none
        titleTextField.layer.addSublayer(titleButtonLine)
        
        let dateButtonLine = CALayer()
        dateButtonLine.frame = CGRect(x: 0.0, y: dateTextField.frame.height - 1, width: dateTextField.frame.width, height: 1.0)
        dateButtonLine.backgroundColor = UIColor.systemGreen.cgColor
        dateTextField.borderStyle = UITextField.BorderStyle.none
        dateTextField.layer.addSublayer(dateButtonLine)
        
        let bodyPartBottomLine = CALayer()
        bodyPartBottomLine.frame = CGRect(x: 0.0, y: bodyPartTextField.frame.height - 1, width: bodyPartTextField.frame.width, height: 1.0)
        bodyPartBottomLine.backgroundColor = UIColor.systemGreen.cgColor
        bodyPartTextField.borderStyle = UITextField.BorderStyle.none
        bodyPartTextField.layer.addSublayer(bodyPartBottomLine)
        
        postButton.layer.cornerRadius = 10
    }
    
    
    
    /* ---------- Table Field Functions ---------- */
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 20
    }
    
    /* ---------- Picker Functions ---------- */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return muscleGroups.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return muscleGroups[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bodyPartTextField.text = muscleGroups[row]
    }

}


