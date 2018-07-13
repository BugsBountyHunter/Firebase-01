//
//  ViewController.swift
//  Firebase-01
//
//  Created by Ahmed SR on 7/5/18.
//  Copyright © 2018 Ahmed. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth


class LoginVC: UIViewController {
    //Outlet
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tapGestur = UITapGestureRecognizer(target: self, action: #selector(exitEditing))
        
         view.addGestureRecognizer(tapGestur)
    }
    
    @objc func exitEditing(){
        view.endEditing(true)
    }
    
    //Action
    @IBAction func loginBtn(_ sender: UIButton) {
        
        guard let email = emailTxt.text?.trimmingCharacters(in: .whitespaces) , !email.isEmpty else{
            print("email was Empty")
            return
        }
        guard let pass = passTxt.text , !pass.isEmpty else {
            print("pass was empty ")
            return
        }
         self.view.endEditing(true)
         Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            // if found error
            if let loginError = error  {
                print(loginError)
                let alert = UIAlertController(title: "Warring Message!", message: loginError.localizedDescription, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
               // self.present(alert, animated: true)
                self.present(alert,animated: true)
            }
            else{
                self.performSegue(withIdentifier: LOGIN_TO_CHAT, sender: nil)
                }
            
        
            }
        }
    }
    


