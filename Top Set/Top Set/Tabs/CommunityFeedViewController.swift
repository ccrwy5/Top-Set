//
//  CommunityFeedViewController.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit
import Firebase

class CommunityFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var mainRef: DatabaseReference!
    var workoutsList = [Workout]()
    @IBOutlet weak var communityFeedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }

    func loadData(){
        mainRef = Database.database().reference().child("posts")
        
        mainRef.observe(.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.workoutsList.removeAll()
                
                for workouts in snapshot.children.allObjects as! [DataSnapshot] {

                    let workoutObj = workouts.value as? [String:AnyObject]
                    let details = workoutObj?["details"]
                    let date = workoutObj?["workoutDate"]
                    let title = workoutObj?["title"]
                    let postID = workoutObj?["postID"]
                    let bodyPart = workoutObj?["bodyPart"]
                    let timestamp = workoutObj?["timestamp"]

                    let workout = Workout(id: postID as! String, title: title as! String, date: date as! String, details: details as! String, bodyPart: bodyPart as! String, timestamp: timestamp as! Double)

                    self.workoutsList.append(workout)

                    //print(self.workoutsList)
                    
                }
                self.workoutsList = self.workoutsList.reversed()
                self.communityFeedTableView.reloadData()

            }
        })



    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as! CommunityTableViewCell
        
        let workout: Workout
        workout = workoutsList[indexPath.row]
        cell.titleLabel.text = workout.title
        cell.bodyPartLabel.text = workout.bodyPart
        cell.dateLabel.text = "Workout on\n\(workout.date)"
        cell.descriptionCell.text = workout.details
        
        return cell
    }
    
}
