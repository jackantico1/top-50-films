//
//  ViewController.swift
//  top-50-films
//
//  Created by Jack Antico on 4/9/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let filmNames: [String] = ["Godfather", "The Wizard of Oz", "Citezen Kane", "The Shawshank Redemption", "Pulp Fiction", "Casablanca", "The Godfather: Part II", "E.T. The Extra-Terrestrial", "2001: A Space Odyssey", "Schindler's List", "Star Wars", "Back to the Future", "Raiders of the Lost Ark", "Forrest Gump", "Gone With the Wind", "To Kill A Mockingbird", "Apocalypse Now", "Annie Hall", "Goodfellas", "It's a Wonderful Life", "Chinatown", "The Silence of the Lambs", "Lawrence of Arabia", "Jaws", "The Sounds of Music", "Singin' in the Rain", "The Breakfast Club", "The Graduate", "Blade Runner", "One Flew Over the Cuckoo's Nest", "The Princess Bride", "The Empire Strikes Back", "Fargo", "American Beauty", "A Clockwork Orange", "Ferris Bueller's Day Off", "Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb", "When Harry Met Sally", "The Shining", "Fight Club", "Psycho", "Alien", "Toy Story", "The Matrix", "Titanic", "Saving Private Ryan", "Some Like It Hot", "The Usual Suspects", "Rear Window", "Jurassic Park"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeFilmsWatched()
        overrideUserInterfaceStyle = .dark
        tableView.delegate = self
        tableView.dataSource = self
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let uid = UIDevice.current.identifierForVendor!.uuidString
        let filmsWatchedRef = ref.child("users/\(uid)")
        let refHandle = filmsWatchedRef.observe(DataEventType.value, with: { (snapshot) in
            self.tableView.reloadData()
        })
        
    }
    
    @IBAction func shareYourListPressed(_ sender: UIButton) {
        let uid = UIDevice.current.identifierForVendor!.uuidString
        getDataSnapshot(path: "users/\(uid)") { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var filmsWatchedStr = value?["filmsWatched"] as? String ?? "00000000000000000000000000000000000000000000000000"
            var filmsWatchedArray: [String] = []
            var filmsWatchedPercentage = 0
            var counter = 0
            for char in filmsWatchedStr {
                if (char == "1") {
                    filmsWatchedArray.append(self.filmNames[counter])
                    filmsWatchedPercentage += 2
                }
                counter += 1
            }
            let sms: String = "sms:+1234567890&body=I've watched \(filmsWatchedPercentage)% of the Top 50 Films, including \(filmsWatchedArray.joined(separator: ", ")). We should try to watch some together!"
            let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
        }
    }
    
    func initalizeFilmsWatched() {
        let uid = UIDevice.current.identifierForVendor!.uuidString
        getDataSnapshot(path: "users") { (datasnapshot) in
            if (datasnapshot.hasChild(uid)) {
                return
            } else {
                self.setValueInDatabase(path: "users/\(uid)", object: ["filmsWatched": "00000000000000000000000000000000000000000000000000"])
            }
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
        let uid = UIDevice.current.identifierForVendor!.uuidString
        getDataSnapshot(path: "users/\(uid)") { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let filmsWatched = value?["filmsWatched"] as? String ?? "00000000000000000000000000000000000000000000000000"
            let filmValue = filmsWatched[indexPath.row]
            if (filmValue == "0") {
                cell.myCellButton.setImage(UIImage(named: "unchecked"), for: .normal)
            } else if (filmValue == "1") {
                cell.myCellButton.setImage(UIImage(named: "checked"), for: .normal)
            } else {
                cell.myCellButton.setImage(UIImage(named: "unchecked"), for: .normal)
            }
        }
        cell.myCellLabel.text = self.filmNames[indexPath.row]
        cell.backgroundColor = UIColor.black
        cell.selectionStyle = .none
        return cell
    }
}

extension UIViewController {
    func getDataSnapshot(path: String, completion: @escaping (DataSnapshot) -> ()) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("\(path)").observeSingleEvent(of: .value, with: { (snapshot) in
            completion(snapshot)
        }) { (error) in
            self.showErrorMessage(messageTitle: "Error:", messageText: error.localizedDescription)
        }
    }
    
    func setValueInDatabase(path: String, object: [String: Any]) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(path).setValue(object)
    }
    
    func showErrorMessage(messageTitle: String, messageText: String) {
        let alert = UIAlertController(title: messageTitle, message: messageText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
