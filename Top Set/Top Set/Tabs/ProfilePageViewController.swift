//
//  ProfilePageViewController.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!

    var listingsList = [Workout]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
//    func populateWorkouts(){
//        let currentUser = (Auth.auth().currentUser?.uid)!
//        let personalRef = Database.database().reference().child("users").child("profile").child(currentUser).child("User's Workouts")
//
//        personalRef.observe(.value, with: {(snapshot) in
//            if snapshot.childrenCount > 0 {
//                self.listingsList.removeAll()
//
//                for listing in snapshot.children.allObjects as! [DataSnapshot] {
//                    let listingObject = listing.value as? [String:AnyObject]
//                    let title = listingObject?["bookTitle"]
//                    let author = listingObject?["bookAuthor"]
//                    let id = listingObject?["id"]
//                    let price = listingObject?["price"]
//
//                    let workout = Workout(id: id, title: title, exercises: <#T##[Exercise]#>)
//
//                    self.listingsList.append(artist)
//                }
//                self.listTableView.reloadData()
//            }
//        })
//    }
    
}
