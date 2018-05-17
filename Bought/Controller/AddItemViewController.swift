//
//  AddItemViewController.swift
//  Bought
//
//  Created by Marx, Brian on 5/15/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import UIKit

protocol AddItemDelegate {
    func didAddItem(_ controller: AddItemViewController, item: Item, aisle: Ailse, in section: Int)
}

class AddItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var trip = TripModel()
    var aisle = [Ailse]()
    var editedIndexPath = IndexPath()
    var delegate: AddItemDelegate?
    
    @IBOutlet weak var textfieledOutlet: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieledOutlet.delegate = self
        navigationItem.title = "Choose an aisle"
        for ailse in trip.ailses {
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
        cell?.textLabel?.text = trip.ailses[indexPath.row].name
        cell?.detailTextLabel?.text = String(trip.ailses[indexPath.row].items.count)
//        let label = cell.viewWithTag(222) as! UILabel
//        label.text = String(trip.ailses[indexPath.section].items.count)
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
                delegate?.didAddItem(self, item: item, aisle: trip.ailses[index.row], in: editedIndexPath.row)
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
