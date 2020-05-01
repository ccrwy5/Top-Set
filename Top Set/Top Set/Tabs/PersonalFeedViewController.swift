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

    var personalWorkoutsList = [Workout]()
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
                    let bodyPart = workoutObj?["bodyPart"]
                    let timestamp = workoutObj?["timestamp"]

                    let workout = Workout(id: postID as! String, title: title as! String, date: date as! String, details: details as! String, bodyPart: bodyPart as! String, timestamp: timestamp as! Double)

                    self.personalWorkoutsList.append(workout)

                    print(self.personalWorkoutsList)
                    
                }
                self.personalWorkoutsList = self.personalWorkoutsList.reversed()
                self.personalFeedTableView.reloadData()

            }
        })



    }
    
    
    
    
    /* ---------- Table View Functions ---------- */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalWorkoutsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalCell", for: indexPath) as! PersonalTableViewCell
        
        let myWorkout: Workout
        myWorkout = personalWorkoutsList[indexPath.row]
        cell.titleLabel.text = myWorkout.title
//        cell.bodyPartLabel.text = workout.bodyPart
//        cell.dateLabel.text = "Workout on\n\(workout.date)"
//        cell.descriptionCell.text = workout.details
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let currentUser = (Auth.auth().currentUser?.uid)!
        let selectedWorkout = self.personalWorkoutsList[indexPath.row]
        
        let deleteSwipe = UIContextualAction(style: .destructive, title: "Delete Workout") {  (contextualAction, view, boolValue) in

            let localDeleteRef = Database.database().reference().child("users").child("profile").child(currentUser).child("User's Workouts")
            let indivWorkout = localDeleteRef.child(selectedWorkout.id)
            
            var mainID: String = ""
            indivWorkout.observeSingleEvent(of: .value) { (snapshot) in
                let dict = snapshot.value as! [String: Any]
                mainID = dict["main_feed_id"] as! String
                print("MainID: \(mainID)")
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
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteSwipe])
        return swipeActions
    }
    


}
