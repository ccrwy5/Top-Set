//
//  Model.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/29/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import Foundation

public struct Exercise {
    var name: String
    var sets: [Sets]

    
    public init(name: String, sets: [Sets]) {
        self.name = name
        self.sets = sets
    }
}

public struct Sets {
    var weight: Int
    var reps: Int
    
    public init(weight: Int, reps: Int){
        self.weight = weight
        self.reps = reps
    }
}
