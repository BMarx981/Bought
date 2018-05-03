//
//  EditItemViewController.swift
//  Bought
//
//  Created by Marx, Brian on 3/1/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import UIKit
import Firebase

protocol EditItemDelegate {
    func didEditItem(_ controller: EditItemViewController, item: Item)
}

class EditItemViewController: UIViewController {
    
    var delegate: EditItemDelegate?
    @IBOutlet weak var editTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
