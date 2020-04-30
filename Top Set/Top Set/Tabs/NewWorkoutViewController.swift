//
//  NewWorkoutViewController.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit
import Firebase




class NewWorkoutViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    

    

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    let dateFormatter = DateFormatter()
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let postRef = Database.database().reference().child("posts").childByAutoId()
    

    var exercisesList = [String]()
    var setsList = [Int]()
    var repsList = [Int]()
    var RPEList = [Int]()
    
    let numbersOptionsTwenty = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    let numbersOptionsTen = [1,2,3,4,5,6,7,8,9,10]
    
    var twoDimensionalArray = [[String]]()
    
    var twoD = [
        [], // section 1
        [], // section 2
        [] // section 3
    ]
    var allExercisesCollection = [String: [String]]()

    
    var headers = [String]()
    
    let repsNumberPicker = UIPickerView()
    let setsNumberPicker = UIPickerView()
    let RPENumberPicker = UIPickerView()
    
//    let insertPopUp = UIAlertController(title: "Add Exercise", message: "", preferredStyle: UIAlertController.Style.alert)
    var insertPopUp = UIAlertController()


    
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

        setsNumberPicker.delegate = self
        setsNumberPicker.tag = 1
        repsNumberPicker.delegate = self
        repsNumberPicker.tag = 2
        RPENumberPicker.delegate = self
        RPENumberPicker.tag = 3
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        //Alert.addExercise(on: self)
        
        insertPopUp = UIAlertController(title: "Add Exercise", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default){(_) in
            let exerciseName = self.insertPopUp.textFields?[0].text
            let sets = Int((self.insertPopUp.textFields?[1].text)!)
            let reps = Int((self.insertPopUp.textFields?[2].text)!)
            let RPE = Int((self.insertPopUp.textFields?[3].text)!)
            //print(sets)
            

            self.exercisesList.append(exerciseName ?? "No Name Provided :(")
            self.repsList.append(reps ?? 0)
            self.setsList.append(sets ?? 0)
            self.RPEList.append(RPE ?? 0)
            

            
            let indexPath = IndexPath(row: self.exercisesList.count - 1, section: 0)
            self.exercisesTableView.beginUpdates()
            self.exercisesTableView.insertRows(at: [indexPath], with: .right)
            self.exercisesTableView.endUpdates()

            

        }
        

        insertPopUp.addTextField { (nameTextField) in
            nameTextField.placeholder = "Exercise name"
        }
        insertPopUp.addTextField { (setsTextField) in
            setsTextField.placeholder = "Sets"
            setsTextField.inputView = self.setsNumberPicker

        }
        
        insertPopUp.addTextField { (repsTextField) in
            repsTextField.placeholder = "Reps"
            repsTextField.inputView = self.repsNumberPicker
        }
        
        insertPopUp.addTextField { (RPETextField) in
            RPETextField.placeholder = "RPE"
            RPETextField.inputView = self.RPENumberPicker
        }

        
        insertPopUp.addAction(addAction)
        insertPopUp.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(insertPopUp, animated: true)
        
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
                "exercises": exercisesList,
                "sets": setsList,
                "reps": repsList
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
                "exercises": exercisesList,
                "sets": setsList,
                "reps": repsList
            ] as [String: Any]

            personalFeedRef.updateChildValues(listingObject) { (error, ref) in
                if error == nil{
                    print("done 2")
                }
            }
        //}
        
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
        
        postButton.layer.cornerRadius = 10
        toolbar.backgroundColor = UIColor.systemGray
    }
    
    
    
    /* ---------- Table View Functions ---------- */
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            //return twoDimensionalArray[section].count
        return exercisesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exercisesTableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExercisesTableViewCell
    
        let exerciseName = exercisesList[indexPath.row]
        let setCount = setsList[indexPath.row]
        let repCount = repsList[indexPath.row]
        let RPE = RPEList[indexPath.row]
        
        cell.setLabel.text = "\(indexPath.row + 1)"
        cell.exerciseNameLabel.text = exerciseName
        cell.setsLabel.text = String(setCount)
        cell.repsLabel.text = String(repCount)
        cell.RPELabel.text = "(RPE @\(RPE))"
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    

    /* ---------- Picker View Functions ---------- */

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 || pickerView.tag == 2 {
            return numbersOptionsTwenty.count
        } else if pickerView.tag == 3 {
            return numbersOptionsTen.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 || pickerView.tag == 2 {
            return String(numbersOptionsTwenty[row])
        } else if pickerView.tag == 3 {
            return String(numbersOptionsTen[row])
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            insertPopUp.textFields![1].text = String(numbersOptionsTwenty[row])
        } else if pickerView.tag == 2 {
            insertPopUp.textFields![2].text = String(numbersOptionsTwenty[row])
        } else if pickerView.tag == 3 {
            insertPopUp.textFields![3].text = String(numbersOptionsTen[row])
        }
            
    }
    
     
    
}


