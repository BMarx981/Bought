//
//  TripTableViewController.swift
//  Bought
//
//  Created by Marx, Brian on 5/3/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import UIKit
import Firebase

class TripTableViewController: UITableViewController {
    
    var trip = TripModel()
    var sectionNames = [String]()
    var fruit = ["grapes", "bananas"]
    var veg = ["brocolli", "carrots", "asparagus"]
    var carbs = ["bread", "cereal", "muffins"]
    var dairy = ["milk", "orange juice", "eggs", "butter"]
    var frozen = ["shrimp", "burritos", "pizza"]
    var isItemExpanded: Bool? = true
    var ailses = [String:[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ailses = ["Fruit": fruit, "Veggies": veg, "Carbs": carbs, "Dairy": dairy, "Frozen": frozen]
        for key in ailses.keys {
            sectionNames.append(key)
        }
        
        for item in ailses {
            trip.ailse[item.key] = trip.convertToItems(item.value)
        }

        trip.name = "Stop and Shop"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleExpandClose(button: UIButton) {
        
        let section = button.tag
        var indexPaths = [IndexPath]()
        let sectionName = Array(trip.ailse.keys)
        
        for row in (trip.ailse[sectionName[section]]?.indices)! {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        isItemExpanded = (trip.ailse[sectionName[section]]?[0].isExpanded)!
        
        button.setTitle(isItemExpanded! ? "Expand" : "Close", for: .normal)

        if isItemExpanded! {
            tableView.deleteRows(at: indexPaths, with: .fade)
            trip.ailse[sectionName[section]]?[0].isExpanded = !(trip.ailse[sectionName[section]]?[0].isExpanded)!
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
            trip.ailse[sectionName[section]]?[0].isExpanded = !(trip.ailse[sectionName[section]]?[0].isExpanded)!
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return trip.ailse.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nameList = Array(trip.ailse.keys)
        if !trip.ailse[nameList[section]]![0].isExpanded {
            return 0
        }
        return nameList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let list = Array(trip.ailse.keys)
        return list[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .purple
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
        return button
    }
    
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let nameOfList = Array(trip.ailse.keys)
        let items = trip.ailse[nameOfList[indexPath.section]]
        cell.textLabel?.text = items![indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
