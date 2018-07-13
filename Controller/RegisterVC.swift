//
//  RegisterVC.swift
//  Firebase-01
//
//  Created by Ahmed SR on 7/7/18.
//  Copyright © 2018 Ahmed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterVC: UIViewController {
  
    //outlet
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var rePassTxt: UITextField!
    //Action
    @IBAction func registerBtn(_ sender: UIButton) {
        
        guard let name = nameTxt.text?.trimmingCharacters(in: .whitespaces),!name.isEmpty else {
            print("name not found")
            return
        }
        guard let email = emailTxt.text?.trimmingCharacters(in: .whitespaces) , !email.isEmpty else {
            print("email not found")
            return
        }
        guard let pass = passTxt.text , !pass.isEmpty else {
            print("pass not found")
            return
        }
        guard let rePass = rePassTxt.text , !rePass.isEmpty else {
            print("rePass not found")
            return
        }
        
        // Condtion for match rwo pass
        guard pass == rePass else {
            print("password not match")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: pass) { (authResult,error) in
            if let createAccountError = error {
                print(createAccountError)
            }else{
                let alert = UIAlertController(title:"Registration", message:"Registration Successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.performSegue(withIdentifier: REGISTER_TO_CHAT_VC , sender: nil)
                }
        }
    }
    //Dissmiss Register Screen
    @IBAction func closeRegistrationScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


}
