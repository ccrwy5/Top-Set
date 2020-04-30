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
    var numberOfSets: Int
    var weightAndReps: [Int: [Int:Int]] // [# of Sets: [Weight:Reps]]

    
    public init(name: String, numberOfSets: Int, weightAndReps: [Int:[Int:Int]]) {
        self.name = name
        self.numberOfSets = numberOfSets
        self.weightAndReps = weightAndReps
    }
}


