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
    func didEditSection(_ controller: EditItemViewController, ailse: Ailse, at indexPath: IndexPath)
}

class EditItemViewController: UIViewController {
    
    var delegate: EditItemDelegate?
    var item = Item()
    var section: String?
    var ailse = Ailse()
    var index = IndexPath(row: 0, section: 0)
    var isSection = false
    
    @IBOutlet weak var editTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTextfield.delegate = self
        if let sectionName = section {
            navigationItem.title = sectionName
        } else {
            navigationItem.title = item.name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EditItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == editTextfield {
            textField.resignFirstResponder()
            item.name = textField.text ?? item.name
            navigationItem.title = item.name
            delegate?.didEditItem(self, item: item, at: index)
            navigationController?.popViewController(animated: true)
        } else {
            textField.becomeFirstResponder()
            item.name = textField.text!
        }
        return true
    }
}
