//
//  ProfilePageViewController.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var goalsTableView: UITableView!
    

    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    @IBOutlet weak var enterGoalTextField: UITextField!
    @IBOutlet weak var addGoatButton: UIButton!
    
    
    var goalList = [Goal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentProfileInfo()
        setupUI()
        loadData()

    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you would like to log out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            try! Auth.auth().signOut()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)

        
        
    }
    
    func loadCurrentProfileInfo(){
        let currentUser = Auth.auth().currentUser?.displayName
        
        userNameLabel.text = currentUser
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        let currentUserImage = Auth.auth().currentUser?.photoURL
        self.profileImageView.load(url: currentUserImage!)
                
    }
    
    func setupUI(){
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        logOutButton.layer.cornerRadius = 10
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: enterGoalTextField.frame.height - 1, width: enterGoalTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.systemGreen.cgColor
        enterGoalTextField.borderStyle = UITextField.BorderStyle.none
        enterGoalTextField.layer.addSublayer(bottomLine)
        
        addGoatButton.layer.cornerRadius = 12
        
    }
    
    @IBAction func addGoalClicked(_ sender: Any) {
        let currentUser = (Auth.auth().currentUser?.uid)!
        let goalTitle: String
        
        if enterGoalTextField.text!.isEmpty {
            // alert
            print("enter goal")
            return
        } else {
            goalTitle = enterGoalTextField.text!
        }
        
        
        
        let personalFeedRef = Database.database().reference().child("users").child("profile").child(currentUser).child("User's Goals").childByAutoId()
        let listingObject = [
            "goalID": personalFeedRef.key!,
            "timestamp": [".sv":"timestamp"],
            "title": goalTitle
        ] as [String: Any]

        personalFeedRef.updateChildValues(listingObject) { (error, ref) in
            if error == nil{
                print("goal added")
                self.enterGoalTextField.text = ""
            }
        }
    }
    
    
    func loadData(){
        
        let currentUser = Auth.auth().currentUser?.uid
        let personalRef = Database.database().reference().child("users").child("profile").child(currentUser!).child("User's Goals")
        
        personalRef.observe(.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.goalList.removeAll()
                
                for workouts in snapshot.children.allObjects as! [DataSnapshot] {

                    let workoutObj = workouts.value as? [String:AnyObject]
                    let title = workoutObj?["title"]
                    let goalID = workoutObj?["goalID"]

                    let goal = Goal(id: goalID as! String, goalTitle: title as! String)

                    self.goalList.append(goal)
                    
                }
                self.goalList = self.goalList.reversed()
                print(self.goalList)
                self.goalsTableView.reloadData()

            }
        })
    }
    
    /* ------------ Table View Functions ---------------- */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as! GoalTableViewCell
        
        let goal: Goal
        goal = goalList[indexPath.row]
        cell.goalTitleLabel.text = goal.goalTitle
        
        if let giveUpButton = cell.contentView.viewWithTag(102) as? UIButton {
            giveUpButton.addTarget(self, action: #selector(giveUp(_ :)), for: .touchUpInside)
        }
        
        if let checkMarkButton = cell.contentView.viewWithTag(101) as? UIButton {
            checkMarkButton.addTarget(self, action: #selector(reachedGoal(_ :)), for: .touchUpInside)
        }
        
        return cell
    }
    
    
    @objc func reachedGoal(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: goalsTableView)
        guard let indexPath = goalsTableView.indexPathForRow(at: point) else {
            return
        }
        print("check mark clicked")
        let currentUser = Auth.auth().currentUser?.uid
        let selectedGoal = self.goalList[indexPath.row]
        let localDeleteRef = Database.database().reference().child("users").child("profile").child(currentUser!).child("User's Goals")
        let indivGoal = localDeleteRef.child(selectedGoal.id)
        
        
        let alert = UIAlertController(title: "Success?", message: "Did you reach this goa?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            indivGoal.observeSingleEvent(of: .value) { (snapshot) in
                let dict = snapshot.value as! [String: Any]
                                        
                self.goalList.remove(at: indexPath.row)
                self.goalsTableView.beginUpdates()
                self.goalsTableView.deleteRows(at: [indexPath], with: .automatic)
                self.goalsTableView.endUpdates()
                
                
                indivGoal.setValue(nil)
                
            
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)

    }
    
    @objc func giveUp(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: goalsTableView)
        guard let indexPath = goalsTableView.indexPathForRow(at: point) else {
            return
        }
        print("delete clicked")
        let currentUser = Auth.auth().currentUser?.uid
        let selectedGoal = self.goalList[indexPath.row]
        let localDeleteRef = Database.database().reference().child("users").child("profile").child(currentUser!).child("User's Goals")
        let indivGoal = localDeleteRef.child(selectedGoal.id)
        
        
        let alert = UIAlertController(title: "Give Up?", message: "Are you sure you want to delete this goal?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            indivGoal.observeSingleEvent(of: .value) { (snapshot) in
                let dict = snapshot.value as! [String: Any]
                                        
                self.goalList.remove(at: indexPath.row)
                self.goalsTableView.beginUpdates()
                self.goalsTableView.deleteRows(at: [indexPath], with: .automatic)
                self.goalsTableView.endUpdates()
                
                
                indivGoal.setValue(nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)

    }
    

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
