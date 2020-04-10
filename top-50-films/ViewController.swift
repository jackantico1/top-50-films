//
//  ViewController.swift
//  top-50-films
//
//  Created by Jack Antico on 4/9/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit

struct defaultsKeys {
    static let firstUseKey = "firstUseKey"
    static let filmsWatchedKey = "filmsWatchedKey"
}



class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let filmNames: [String] = ["Godfather", "The Wizard of Oz", "Citezen Kane", "The Shawshank Redemption", "Pulp Fiction"] //"Casablanca", "The Godfather: Part II", "E.T. The Extra-Terrestrial", "2001: A Space Odyssey", "Schindler's List", "Star Wars", "Back to the Future", "Raiders of the Lost Ark", "Forrest Gump", "Gone With the Wind", "To Kill A Mockingbird", "Apocalypse Now", "Annie Hall", "Goodfellas", "It's a Wonderful Life", "Chinatown", "The Silence of the Lambs", "Lawrence of Arabia", "Jaws", "The Sounds of Music", "Singin' in the Rain", "The Breakfast Club", "The Graduate", "Blade Runner", "One Flew Over the Cuckoo's Nest", "The Princess Bride", "The Empire Strikes Back", "Fargo", "American Beauty", "A Clockwork Orange", "Ferris Bueller's Day Off", "Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb", "When Harry Met Sally", "The Shining", "Fight Club", "Psycho", "Alien", "Toy Story", "The Matrix", "Titanic", "Saving Private Ryan", "Some Like It Hot", "The Usual Suspects", "Rear Window", "Jurassic Park"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if (checkIfFirstTime()) {
            initalizeFilmsWatched()
        }
        //runDebug()
    }
    
    func initalizeFilmsWatched() {
        print("initalizeFilmsWatched called")
        let defaults = UserDefaults.standard
        defaults.set([0, 0, 0, 0, 0], forKey: defaultsKeys.filmsWatchedKey)
    }
    
    func checkIfFirstTime() -> Bool {
        print("checkIfFirstTime called")
        let defaults = UserDefaults.standard
        let firstTime = defaults.string(forKey: defaultsKeys.firstUseKey) ?? nil
        if firstTime == nil {
            defaults.set("", forKey: defaultsKeys.firstUseKey)
            return true
        } else {
            return false
        }
    }
    
    func runDebug() {
        let defaults = UserDefaults.standard
        if let filmWatched = defaults.array(forKey: defaultsKeys.filmsWatchedKey) {
            print(filmWatched)
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyCustomCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCustomCell
        cell.filmNum = indexPath.row
        let filmsWatched = returnFilmsWatched()
        let filmValue = filmsWatched[indexPath.row] as? Int ?? 0
        if (filmValue == 0) {
            //cell.myImageView.image = UIImage(named: "unchecked")
            cell.myCellButton.setImage(UIImage(named: "unchecked"), for: .normal)
        } else if (filmValue == 1) {
            //cell.myImageView.image = UIImage(named: "checked")
            cell.myCellButton.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            //cell.myImageView.image = UIImage(named: "unchecked")
            cell.myCellButton.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        cell.myCellLabel.text = self.filmNames[indexPath.row]
        return cell
    }
}

extension UIViewController {
    func returnFilmsWatched() -> [Any] {
        let defaults = UserDefaults.standard
        let filmsWatched = defaults.array(forKey: defaultsKeys.filmsWatchedKey) ?? [0, 0, 0, 0, 0]
        return filmsWatched
    }
}
