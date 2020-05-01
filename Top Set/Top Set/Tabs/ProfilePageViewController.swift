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
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var listingsList = [Workout]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentProfileInfo()
        setupUI()

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
