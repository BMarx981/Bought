//
//  LoginViewController.swift
//  Bought
//
//  Created by Marx, Brian on 2/7/18.
//  Copyright © 2018 Marx, Brian. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    let loginToTrips = "LoginToTrips"
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = userName.text,
            let password = password.text,
            email.count > 0,
            password.count > 0
            else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Failed to Sign In",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.loginToTrips, sender: nil)
                self.userName.text = nil
                self.password.text = nil
            }
        }
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func signInPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: self.userName.text!, password: self.password.text!)
                }
            })
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userName {
            password.becomeFirstResponder()
        }
        if textField == password {
            textField.resignFirstResponder()
        }
        return true
    }
}
