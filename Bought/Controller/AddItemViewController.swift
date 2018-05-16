//
//  AddItemViewController.swift
//  Bought
//
//  Created by Marx, Brian on 5/15/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import UIKit

protocol AddItemDelegate {
    func didAddItem(_ controller: AddItemViewController, item: Item, ailse: Ailse, at indexPath: IndexPath)
}

class AddItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var trip = TripModel()
    var ailses = [Ailse]()
    var editedIndexPath = IndexPath()
    var delegate: AddItemDelegate?
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var textfieledOutlet: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieledOutlet.delegate = self
        navigationItem.title = "Choose an ailse"
        itemLabel?.text = "Enter the new item name"
        for ailse in trip.ailses {
            ailses.append(ailse)
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
        itemLabel?.text = "Selected ailse: \(ailses[indexPath.row].name)"
        editedIndexPath = indexPath
    }
    
    // MARK: - TableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ailses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = trip.ailses[indexPath.row].name
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let item = Item()
        if textField == textfieledOutlet {
            textField.becomeFirstResponder()
            var index = IndexPath()
            if let selection = tableView.indexPathForSelectedRow {
                index = selection
                print(index)
            }
            
            item.name = textfieledOutlet.text!
            delegate?.didAddItem(self, item: item, ailse: trip.ailses[index.row], at: editedIndexPath)
            textfieledOutlet.text! = ""
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
