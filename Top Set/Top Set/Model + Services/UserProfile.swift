//
//  UserProfile.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import Foundation

class UserProfile {
    var uid: String
    var username: String
    var photoURL: URL
    var email: String
    var fullName: String
    
    init(uid: String, username: String, photoURL:URL, email: String, fullName: String) {
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
        self.email = email
        self.fullName = fullName
    }
}
