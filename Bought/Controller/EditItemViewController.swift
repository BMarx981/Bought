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
    func didEditItem(_ controller: EditItemViewController, item: Item, at indexPath: IndexPath)
}

class EditItemViewController: UIViewController {
    
    var delegate: EditItemDelegate?
    var item = Item()
    var index = IndexPath(row: 0, section: 0)
    @IBOutlet weak var ItemNameOutlet: UILabel!
    @IBOutlet weak var editTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemNameOutlet.text = item.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EditItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == editTextfield {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        item.name = textField.text!
        ItemNameOutlet!.text = item.name
        delegate?.didEditItem(self, item: item, at: index)
    }
}
