//
//  AddItemViewController.swift
//  Bought
//
//  Created by Marx, Brian on 5/15/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import UIKit

protocol AddItemDelegate {
    func didAddItem(item: Item, in section: Int)
}

class AddItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var trip = TripModel()
    var aisle = [Aisle]()
    var editedIndexPath = IndexPath()
    var delegate: AddItemDelegate?
    
    @IBOutlet weak var textfieledOutlet: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieledOutlet.delegate = self
        textfieledOutlet.clearButtonMode = .always
        navigationItem.title = "Choose an aisle"
        for ailse in trip.aisles {
            aisle.append(ailse)
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editedIndexPath = indexPath
    }
    
    // MARK: - TableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aisle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? UITableViewCell
        cell?.textLabel?.text = trip.aisles[indexPath.row].name
        cell?.detailTextLabel?.text = String(trip.aisles[indexPath.row].items.count)

        return cell!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let item = Item()
        if textField == textfieledOutlet {
            textField.becomeFirstResponder()
            var index = IndexPath()
            if let selection = tableView.indexPathForSelectedRow {
                index = selection
                item.name = textfieledOutlet.text!
                delegate?.didAddItem(item: item, in: editedIndexPath.row)
                textfieledOutlet.text! = ""
            }
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
