//
//  MyCustomCell.swift
//  top-50-films
//
//  Created by Jack Antico on 4/9/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Firebase

class MyCustomCell: UITableViewCell {
    var filmNum: Int = 0
    @IBOutlet weak var myCellButton: UIButton!
    @IBOutlet weak var myCellLabel: UILabel!
    @IBAction func buttonPressed(_ sender: UIButton) {
        let uid = UIDevice.current.identifierForVendor!.uuidString
        getDataSnapshot(path: "users/\(uid)") { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var filmsWatched = value?["filmsWatched"] as? String ?? "00000000000000000000000000000000000000000000000000"
            if (filmsWatched[self.filmNum] == "0") {
                filmsWatched = self.replace(myString: filmsWatched, self.filmNum, "1")
                self.setValueInDatabase(path: "users/\(uid)", object: ["filmsWatched": filmsWatched])
            } else if (filmsWatched[self.filmNum] == "1") {
                filmsWatched = self.replace(myString: filmsWatched, self.filmNum, "0")
                self.setValueInDatabase(path: "users/\(uid)", object: ["filmsWatched": filmsWatched])
            } else {
                filmsWatched = self.replace(myString: filmsWatched, self.filmNum, "0")
                self.setValueInDatabase(path: "users/\(uid)", object: ["filmsWatched": filmsWatched])
            }
        }
    }
}

extension UITableViewCell {
    func getDataSnapshot(path: String, completion: @escaping (DataSnapshot) -> ()) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("\(path)").observeSingleEvent(of: .value, with: { (snapshot) in
            completion(snapshot)
        }) { (error) in
            print("Error getting DataSnapshot in TableViewCell")
        }
    }
    
    func setValueInDatabase(path: String, object: [String: Any]) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(path).setValue(object)
    }
    
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
}
