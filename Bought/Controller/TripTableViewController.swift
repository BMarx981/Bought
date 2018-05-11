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
    var trip2 = TripModel()
    var trips = [TripModel]()
    var sectionNames = [String]()
    var fruit = ["grapes", "bananas"]
    var veg = ["brocolli", "carrots", "asparagus"]
    var carbs = ["bread", "cereal", "muffins"]
    var dairy = ["milk", "orange juice", "eggs", "butter"]
    var frozen = ["shrimp", "burritos", "pizza"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ailses = ["Fruit": fruit, "Veggies": veg, "Carbs": carbs, "Dairy": dairy, "Frozen": frozen]
        for key in ailses.keys {
            sectionNames.append(key)
        }
        
        for ailseObj in 0..<ailses.count {
            let ailse = Ailse(name: sectionNames[ailseObj], list: trip.convertToItems(ailses[sectionNames[ailseObj]]!), expand: true)
            trip.ailses.append(ailse)
            trip2.ailses.append(ailse)
        }

        trip.name = "Stop and Shop"
        trip2.name = "Trader Joes"

        trips.append(trip)
        trips.append(trip2)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        let item = trips[indexPath.row].name
        cell.textLabel?.text = item
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tripped = trips[indexPath.row]
        let listVC = storyboard?.instantiateViewController(withIdentifier: "ListsVC") as? ListTableViewController
        listVC?.trip = tripped
        navigationController?.pushViewController(listVC!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
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

}
