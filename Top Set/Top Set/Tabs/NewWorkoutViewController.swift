//
//  NewWorkoutViewController.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit
import Firebase

class NewWorkoutViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    let dateFormatter = DateFormatter()
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var exercisesTableView: UITableView!
    
    let postRef = Database.database().reference().child("posts").childByAutoId()
        
//    let twoDimensionalArray = [
//        ["Bench Press", "Squat", "Deadlift", "Overhead Press"],
//        ["Set 1", "Set 2", "Set 3", "Set 4"],
//        ["Mike", "Matt"]
//    ]
    
    
    var exercises = ["Bench Press", "Squat", "Deadlift", "Overhead Press"]
    
    var headers = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        titleTextField.delegate = self
        postButton.isEnabled = false
        postButton.alpha = 0.5
        [titleTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })

        setupUI()
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.addTarget(self, action: #selector(NewWorkoutViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        
        dateTextField.inputView = datePicker
        
        //headers = twoDimensionalArray[0]


    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        //Alert.addExercise(on: self)
        
        let alert = UIAlertController(title: "Add Exercise", message: "", preferredStyle: UIAlertController.Style.alert)
        let addAction = UIAlertAction(title: "Add", style: .default){(_) in
            let exerciseName = alert.textFields?[0].text

            self.exercises.append(exerciseName!)
            self.exercisesTableView.insertSections(IndexSet(integer: self.exercises.count - 1), with: .right)
            print(self.exercises)
        }
        

        alert.addTextField { (textField) in
            textField.placeholder = "Exercise name"
        }

        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
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
    }
    
    
    @IBAction func handlePostButton(_ sender: Any) {
        
        guard let userProfile = UserService.currentUserProfile else {
            print("error in userProfile")
            return
        }
        guard let title = titleTextField.text else { return }
        guard let workoutDate = dateTextField.text else { return }
        
        if title == "" {
            Alert.showInCompleteFormAlert(on: self)
        } else {
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
                "workoutDate": workoutDate
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
                "workoutDate": workoutDate
            ] as [String: Any]
            
            personalFeedRef.updateChildValues(listingObject) { (error, ref) in
                if error == nil{
                    print("done 2")
                }
            }
        }
        
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
        
        postButton.layer.cornerRadius = 10
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return twoDimensionalArray[section].count
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exercisesTableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        
//        let name = twoDimensionalArray[indexPath.section][indexPath.row]
//        cell.textLabel?.text = "\(name) Section: \(indexPath.section) Row: \(indexPath.row)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return twoDimensionalArray.count
        //return twoDimensionalArray[0].count
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.text = exercises[section]
        label.backgroundColor = UIColor.lightGray
        return label
    }
}
