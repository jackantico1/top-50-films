//
//  ViewController.swift
//  top-50-films
//
//  Created by Jack Antico on 4/9/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let filmNames: [String] = ["Godfather", "The Wizard of Oz", "Citezen Kane", "The Shawshank Redemption", "Pulp Fiction"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyCustomCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCustomCell
        let checkedBox = UIImage(named: "checked")
        let uncheckedBox = UIImage(named: "unchecked")
        if (self.filmNames[indexPath.row].count > 15) {
            cell.myImageView.image = uncheckedBox
        } else {
            cell.myImageView.image = checkedBox
        }
        cell.myCellLabel.text = self.filmNames[indexPath.row]
        return cell
    }
}
