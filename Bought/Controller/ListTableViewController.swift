//
//  ListTableViewController.swift
//  Bought
//
//  Created by Marx, Brian on 2/7/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import UIKit
import Firebase

class ListTableViewController: UITableViewController {
    
    var trip = TripModel()
    var delegate: EditItemDelegate?
    var addItemDelegate: AddItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItemDelegate = self
        delegate = self
        
        navigationItem.title = trip.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Mark : - Bar button Items
    @IBAction func addAilseTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Aisle", message: "Enter the name of the new ailse", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Add Aisle", style: .default) { _ in
            guard let textfield = alert.textFields?.first, let text = textfield.text else { return }
            let newAisle = Aisle()
            newAisle.name = text
            newAisle.isExpanded = true
            self.trip.aisles.append(newAisle)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addItemTapped(_ sender: UIBarButtonItem) {
        
        let add = storyboard?.instantiateViewController(withIdentifier: "addItemVC") as! AddItemViewController
        add.trip = trip
        add.delegate = self
        navigationController?.pushViewController(add, animated: true)
    }
    
    @IBAction func clearAllTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Clear All", message: "Are you sure you'd like to clear all items?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Clear All", style: .default) { _ in
            for aisle in self.trip.aisles {
                aisle.items.removeAll()
            }
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteAilseTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete Aisle", message: "Enter the name of the aisle you wish to delete", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            guard let textfield = alert.textFields?.first, let text = textfield.text else { return }
            let aisleToFind = text.uppercased()
            var index = 0
            var wasFound = false
            for i in 0..<self.trip.aisles.count {
                if self.trip.aisles[i].name.uppercased() == aisleToFind {
                    wasFound = true
                    index = i
                }
            }
            if wasFound {
                self.trip.aisles.remove(at: index)
            }
            
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return trip.aisles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !trip.aisles[section].isExpanded {
            return 0
        }
        return trip.aisles[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return trip.aisles[section].name
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        if trip.aisles[section].items.count == 0 {
            button.setTitle("\(trip.aisles[section].name)", for: .normal)
        } else {
            button.setTitle("Close \(trip.aisles[section].name)", for: .normal)
        }
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tag = section
        let longPressSectionButton = UILongPressGestureRecognizer(target:self, action: #selector(handleSectionLongPress))
        button.addGestureRecognizer(longPressSectionButton)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        return button
    }
    
    //MARK: - Delegate Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let item = trip.aisles[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.name
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        cell.addGestureRecognizer(longPress)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let item = trip.aisles[indexPath.section].items[indexPath.row]
        let isBoughtValue = !item.bought
        item.bought = isBoughtValue
        
        toggleBought(cell, isBought: isBoughtValue)
        let sectionItems = trip.aisles[indexPath.section].items
        let filter = sectionItems.filter { item in item.bought }
        //Close section when all cells are selected.
        if sectionItems.count == filter.count {
            let isItemExpanded = trip.aisles[indexPath.section].isExpanded
            trip.aisles[indexPath.section].isExpanded = !isItemExpanded
            var indexPaths = [IndexPath]()
            
            for row in trip.aisles[indexPath.section].items.indices {
                let ip = IndexPath(row: row, section: indexPath.section)
                indexPaths.append(ip)
            }
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            trip.aisles[indexPath.section].items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }

     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         return true
     }
    
    //MARK: - Handle Functions
    @objc func handleExpandClose(button: UIButton) {
        
        let section = button.tag
        var indexPaths = [IndexPath]()
        let ailseName = trip.aisles[section].name
        
        for row in trip.aisles[section].items.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isItemExpanded = trip.aisles[section].isExpanded
        trip.aisles[section].isExpanded = !isItemExpanded
        
        button.setTitle(isItemExpanded ? "Expand \(ailseName)" : "Close \(ailseName)", for: .normal)
        
        if isItemExpanded {
            tableView.deleteRows(at: indexPaths, with: .top)
        } else {
            tableView.insertRows(at: indexPaths, with: .top)
        }
    }
    
    @objc func handleSectionLongPress(sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 1.0
        if sender.state != UIGestureRecognizerState.ended { return }
        
        let point = sender.location(in: tableView)
        let index = tableView.indexPathForRow(at: point)
        
        if index != nil && sender.state == UIGestureRecognizerState.ended {
            if let indexPath = index {
                let ailseName = trip.aisles[indexPath.section].name
                let alert = UIAlertController(title: "Edit \(ailseName)", message: "Edit the aisle name", preferredStyle: .alert)
                let editAction = UIAlertAction(title: "Change", style: .default) { _ in
                    guard let textfield = alert.textFields?.first, let text = textfield.text else { return }
                    self.trip.aisles[indexPath.section].name = text
                    self.tableView.reloadData()
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addTextField() { textfield in
                    textfield.text = self.trip.aisles[indexPath.section].name
                }
                alert.addAction(editAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 1.0
        if sender.state != UIGestureRecognizerState.ended { return }
        
        let point = sender.location(in: tableView)
        let index = tableView.indexPathForRow(at: point)
        
        if index != nil && sender.state == UIGestureRecognizerState.ended {
            if let indexPath = index {
                let editVC = storyboard?.instantiateViewController(withIdentifier: "EditVC") as? EditItemViewController
                editVC?.item = trip.aisles[indexPath.section].items[indexPath.row]
                editVC?.index = IndexPath(row: indexPath.row, section: indexPath.section)
                editVC?.delegate = self
                tableView.deselectRow(at: indexPath, animated: true)
                navigationController?.pushViewController(editVC!, animated: true)
            }
        }
    }
    
    //MARK: - Toggle bought bool
    func toggleBought(_ cell: UITableViewCell, isBought: Bool) {
        if !isBought {
            setCellToNormal(cell)
        } else {
            setCellToChecked(cell)
        }
    }
    
    func setCellToNormal(_ cell: UITableViewCell) {
        cell.accessoryType = .none
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .black
    }
    
    func setCellToChecked(_ cell: UITableViewCell) {
        cell.accessoryType = .checkmark
        cell.textLabel?.textColor = .gray
        cell.detailTextLabel?.textColor = .gray
    }
}

//Mark: - EditItem Delegate
extension ListTableViewController: EditItemDelegate {
    func didEditItem(_ controller: EditItemViewController, item: Item, at index: IndexPath) {
        guard let cell = tableView.cellForRow(at: index) else { return }
        item.bought = false
        setCellToNormal(cell)
        trip.aisles[index.section].items[index.row] = item
        cell.textLabel?.text = item.name
        tableView.reloadData()
    }
}

//Mark: - AddItem Delegate
extension ListTableViewController: AddItemDelegate {
    
    func didAddItem(item: Item, in section: Int) {
        trip.aisles[section].items.append(item)
        tableView.reloadData()
    }
}
