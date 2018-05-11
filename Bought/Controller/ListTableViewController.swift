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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.title = trip.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleExpandClose(button: UIButton) {
        
        let section = button.tag
        var indexPaths = [IndexPath]()
        let ailseName = trip.ailses[section].name
        
        for row in trip.ailses[section].items.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isItemExpanded = trip.ailses[section].isExpanded
        trip.ailses[section].isExpanded = !isItemExpanded
        
        button.setTitle(isItemExpanded ? "Expand \(ailseName)" : "Close \(ailseName)", for: .normal)
        
        if isItemExpanded {
            tableView.deleteRows(at: indexPaths, with: .top)
        } else {
            tableView.insertRows(at: indexPaths, with: .top)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return trip.ailses.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !trip.ailses[section].isExpanded {
            return 0
        }
        return trip.ailses[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return trip.ailses[section].name
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        button.setTitle("Close \(trip.ailses[section].name)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
        return button
    }
    
    //MARK: - Delegate Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let item = trip.ailses[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.name
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        cell.addGestureRecognizer(longPress)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let item = trip.ailses[indexPath.section].items[indexPath.row]
        let isBoughtValue = !item.bought
        item.bought = isBoughtValue
        
        toggleBought(cell, isBought: isBoughtValue)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            trip.ailses[indexPath.section].items.remove(at: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func toggleBought(_ cell: UITableViewCell, isBought: Bool) {
        if !isBought {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.textColor = .black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .gray
            cell.detailTextLabel?.textColor = .gray
        }
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 1.0
        if sender.state != UIGestureRecognizerState.ended {
            return
        }
        
        let point = sender.location(in: tableView)
        let index = tableView.indexPathForRow(at: point)
        
        if index != nil && sender.state == UIGestureRecognizerState.ended {
            if let indexPath = index {
                let editVC = storyboard?.instantiateViewController(withIdentifier: "EditVC") as? EditItemViewController
                editVC?.item = trip.ailses[indexPath.section].items[indexPath.row]
                editVC?.index = IndexPath(row: indexPath.row, section: indexPath.section)
                tableView.deselectRow(at: indexPath, animated: true)
                navigationController?.pushViewController(editVC!, animated: true)
            }
        }
    }
}

extension ListTableViewController: EditItemDelegate {
    func didEditItem(_ controller: EditItemViewController, item: Item, at: IndexPath) {
        trip.ailses[at.section].items[at.row].name = item.name
        trip.ailses[at.section].items[at.row].price = item.price
    }
}

