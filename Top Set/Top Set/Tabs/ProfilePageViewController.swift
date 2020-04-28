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

    override func viewDidLoad() {
        super.viewDidLoad()


        
    }
    
    

    @IBAction func logoutButtonPressed(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
}
