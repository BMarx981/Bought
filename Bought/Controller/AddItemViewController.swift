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
    var delegate: AddItemDelegate?
    var focusView = IndexPath()
    var purple = UIColor(red: 0.83, green: 0.0, blue: 0.83, alpha: 1.0)
    
    @IBOutlet weak var textfieledOutlet: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieledOutlet.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        textfieledOutlet.clearButtonMode = .always
        navigationItem.title = "Choose an aisle"
        for ailse in trip.aisles {
            aisle.append(ailse)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textfieledOutlet.becomeFirstResponder()
    }
    
    // MARK: - TableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aisle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.textColor = purple
        cell.detailTextLabel?.textColor = purple
        cell.textLabel?.text = trip.aisles[indexPath.row].name
        cell.detailTextLabel?.text = "Total #: \(trip.aisles[indexPath.row].items.count)"

        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let item = Item()
        if textField.text == "" { return true }
        if textField == textfieledOutlet, let indexPath = tableView.indexPathForSelectedRow {
            item.name = textfieledOutlet.text!
            delegate?.didAddItem(item: item, in: indexPath.row)
            textfieledOutlet.text! = ""
            tableView.reloadData()
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    // MARK: - Keyboard Observers
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                let theView = view.viewWithTag(123) as! UITableView
                theView.frame.size.height -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                let theView = view.viewWithTag(123) as! UITableView
                theView.frame.size.height += keyboardSize.height
            }
        }
    }

}
