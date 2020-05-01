//
//  PersonalFeedViewController.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit
import Firebase

class PersonalFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var personalWorkoutsList = [PersonalWorkout]()
    var personalRef: DatabaseReference!
    @IBOutlet weak var personalFeedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData(){
        
        let currentUser = Auth.auth().currentUser?.uid
        personalRef = Database.database().reference().child("users").child("profile").child(currentUser!).child("User's Workouts")
        
        personalRef.observe(.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.personalWorkoutsList.removeAll()
                
                for workouts in snapshot.children.allObjects as! [DataSnapshot] {

                    let workoutObj = workouts.value as? [String:AnyObject]
                    let details = workoutObj?["details"]
                    let date = workoutObj?["workoutDate"]
                    let title = workoutObj?["title"]
                    let postID = workoutObj?["personal_feed_id"]
                    let mainID = workoutObj?["main_feed_id"]
                    let bodyPart = workoutObj?["bodyPart"]
                    let timestamp = workoutObj?["timestamp"]

                    let workout = PersonalWorkout(id: postID as! String, title: title as! String, date: date as! String, details: details as! String, bodyPart: bodyPart as! String, timestamp: timestamp as! Double, mainID: mainID as! String)

                    self.personalWorkoutsList.append(workout)

                    //print(self.personalWorkoutsList)
                    
                }
                self.personalWorkoutsList = self.personalWorkoutsList.reversed()
                self.personalFeedTableView.reloadData()

            }
        })
    }
    
    func updateWorkout(id:String, title: String, details: String, mainID: String){
        let currentUser = Auth.auth().currentUser?.uid
        personalRef = Database.database().reference().child("users").child("profile").child(currentUser!).child("User's Workouts")
        let mainRef = Database.database().reference().child("posts")

        let newValues = [
            "id": id,
            "title": title,
            "details": details
        ]
                
        personalRef.child(id).updateChildValues(newValues)
        mainRef.child(mainID).updateChildValues(newValues)
    }
    
    
    
    
    /* ---------- Table View Functions ---------- */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalWorkoutsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalCell", for: indexPath) as! PersonalTableViewCell
        
        let myWorkout: PersonalWorkout
        myWorkout = personalWorkoutsList[indexPath.row]
        cell.titleLabel.text = myWorkout.title
        cell.bodyPartLabel.text = myWorkout.bodyPart
        cell.descriptionLabel.text = myWorkout.details
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentUser = (Auth.auth().currentUser?.uid)!
        let selectedWorkout = self.personalWorkoutsList[indexPath.row]
        
        
        /* Delete Swipe */
        let deleteSwipe = UIContextualAction(style: .destructive, title: "Delete Workout") {  (contextualAction, view, boolValue) in

            let localDeleteRef = Database.database().reference().child("users").child("profile").child(currentUser).child("User's Workouts")
            let indivWorkout = localDeleteRef.child(selectedWorkout.id)
            
            var mainID: String = ""
            indivWorkout.observeSingleEvent(of: .value) { (snapshot) in
                let dict = snapshot.value as! [String: Any]
                mainID = dict["main_feed_id"] as! String
                //print("MainID: \(mainID)")
                let feedDeleteRef = Database.database().reference().child("posts").child(mainID)
                print("feedDeleteRef = \(feedDeleteRef)")
                            
                
                self.personalWorkoutsList.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
                
                
                indivWorkout.setValue(nil)
                feedDeleteRef.setValue(nil)

            }
        }
        
        /* Update Swipe */
        
        let updateSwipe = UIContextualAction(style: .normal, title: "Update Workout") {  (contextualAction, view, boolValue) in
            let workout = self.personalWorkoutsList[indexPath.row]

            let alertController = UIAlertController(title: workout.title, message: "Give new values to update", preferredStyle: .alert)
            
            let updateAction = UIAlertAction(title: "Update", style: .default){(_) in
                let id = workout.id
                let title = alertController.textFields?[0].text
                let details = alertController.textFields?[01].text
                
                self.updateWorkout(id: id, title: title!, details: details!, mainID: workout.mainID)
            }
        
            alertController.addAction(updateAction)
            alertController.addTextField { (textField) in
                textField.text = workout.title
                
            }
            alertController.addTextField { (textField) in
                textField.text = workout.details
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)


            
        }
        updateSwipe.backgroundColor = UIColor(red: 0/255, green: 173/255, blue: 242/255, alpha: 1.0)
        
        /* Add Actions */
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteSwipe, updateSwipe])
        return swipeActions
    }
    


}
