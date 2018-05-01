//
//  RegisterViewController.swift
//  Bought
//
//  Created by Marx, Brian on 2/7/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func registerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
