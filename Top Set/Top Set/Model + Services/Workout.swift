//
//  Workout.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import Foundation

class Workout {
    var id: String
    var title: String
    var date: String
    var bodyPart: String
    var details: String
    var createdAt: Date
    
    init(id: String, title: String, date: String, details: String, bodyPart: String, timestamp: Double) {
        self.id = id
        self.title = title
        self.date = date
        self.details = details
        self.bodyPart = bodyPart
        self.createdAt = Date(timeIntervalSince1970: timestamp/1000)
    }
}


class PersonalWorkout {
    var id: String
    var title: String
    var date: String
    var bodyPart: String
    var details: String
    var createdAt: Date
    var mainID: String
    
    init(id: String, title: String, date: String, details: String, bodyPart: String, timestamp: Double, mainID: String) {
        self.id = id
        self.title = title
        self.date = date
        self.details = details
        self.bodyPart = bodyPart
        self.createdAt = Date(timeIntervalSince1970: timestamp/1000)
        self.mainID = mainID
    }
}



