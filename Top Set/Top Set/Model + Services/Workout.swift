//
//  Workout.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import Foundation

class Workout {
    var id: String?
    var title: String?
    var exercises: [Exercise]
    
    init(id: String?, title: String?, exercises: [Exercise]) {
        self.id = id
        self.title = title
        self.exercises = exercises
    }
}

//class Exercise {
//    var id: String?
//    var exerciseName: String?
//    var reps: Int?
//    var sets: Int?
//    
//    init(id: String?, exerciseName: String?, reps: Int?, sets: Int?) {
//        self.id = id
//        self.exerciseName = exerciseName
//        self.reps = reps
//        self.sets = sets
//        
//    }
//}
