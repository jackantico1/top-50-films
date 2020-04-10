//
//  MyCustomCell.swift
//  top-50-films
//
//  Created by Jack Antico on 4/9/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
class MyCustomCell: UITableViewCell {
    var filmNum: Int = 0
    @IBOutlet weak var myCellButton: UIButton!
    @IBOutlet weak var myCellLabel: UILabel!
    @IBAction func buttonPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        if var filmsWatched = defaults.array(forKey: defaultsKeys.filmsWatchedKey) {
            if (filmsWatched[filmNum] as! Int == 0) {
                filmsWatched[filmNum] = 1
            } else if (filmsWatched[filmNum] as! Int == 1) {
                filmsWatched[filmNum] = 0
            }
            defaults.set(filmsWatched, forKey: defaultsKeys.filmsWatchedKey)
        }
        let newFilmsWatched = defaults.array(forKey: defaultsKeys.filmsWatchedKey)
        print("newFilmsWatched: \(newFilmsWatched)")
    }
}
