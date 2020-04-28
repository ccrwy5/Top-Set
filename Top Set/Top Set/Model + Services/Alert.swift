//
//  Alert.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/27/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true ) }
    }

    static func showInCompleteFormAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Incomplete Form", message: "Please fill out all fields")
    }
    
    static func invalidEmailAddress(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Invalid Data", message: "That email address is invalid")
    }
    
    static func oneRepMaxFound(on vc: UIViewController, result: Double, units: String) {
        showBasicAlert(on: vc, with: "Calculated one-rep max", message: "Your one rep max is \(result) \(units)")
    }
    
//    static func addExercise(on vc: UIViewController) -> String {
//        let alert = UIAlertController(title: "Add Exercise", message: "", preferredStyle: UIAlertController.Style.alert)
//       
//        let exerciseName = ""
//        let updateAction = UIAlertAction(title: "Update", style: .default){(_) in
//            exerciseName = alert.textFields?[0].text
//            
//            //let genre = alert.textFields?[01].text
//            
//            //self.names.insert(name!, at: 0)
//            //self.tblList.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
//        }
//    
//        alert.addTextField { (textField) in
//            textField.placeholder = "Exercise"
//        }
//
//        
//
//        
//        
//        //alert.setValue(vc, forKey: "contentViewController")
//        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        DispatchQueue.main.async { vc.present(alert, animated: true ) }
//        
//        return exerciseName
//
//    }
    

}
