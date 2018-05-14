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
    @IBOutlet weak var editTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTextfield.delegate = self
        navigationItem.title = item.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EditItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == editTextfield {
            textField.becomeFirstResponder()
            item.name = textField.text ?? item.name
            navigationItem.title = item.name
            delegate?.didEditItem(self, item: item, at: index)
            navigationController?.popViewController(animated: true)
        } else {
            textField.resignFirstResponder()
            item.name = textField.text!
        }
        return true
    }
}
