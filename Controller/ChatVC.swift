//
//  ChatVC.swift
//  Firebase-01
//
//  Created by Ahmed SR on 7/8/18.
//  Copyright © 2018 Ahmed. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController {
    //Outlet
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var imageURL: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    //Function
    
    func setupView(){
        
        guard let user =  Auth.auth().currentUser else {
            return
        }
        if let name = user.displayName {
            nameTxt.text = name
        }
        if let photoURL = user.photoURL{
            imageURL.text = photoURL.absoluteString
            
            
            //dDownload Image
            URLSession.shared.dataTask(with: photoURL) { (data, respose, error) in
                if let error = error {
                    print(error)
                    self.showAlert(title: "Error View image", message: error.localizedDescription)
                }else{
                    if let data = data , let image = UIImage(data: data){
                        DispatchQueue.main.async {
                        
                            self.accountImage.image = image

                        }
                        self.showAlert(title: "Succeed", message: "user profile update")

                    }
                }
            }.resume()
        }
        
    }
    
    
    
    
    //Action
    @IBAction func updateInfoBtn(_ sender: UIButton) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let name = nameTxt.text!
        let photoURL = imageURL.text!
        
        let changeRequest = user.createProfileChangeRequest()
        
        changeRequest.photoURL = NSURL(string:photoURL)! as URL
        changeRequest.displayName = name
        changeRequest.commitChanges { (error) in
            if let error =  error {
             self.showAlert(title: "Error Message .. ", message: error.localizedDescription)
            }else {
              self.showAlert(title: " Succeed operation ", message: "Data uploaded")
                self.setupView()
            }
        }
    }
    
    
    @IBAction func changeEmail(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else{return}
        let alert = UIAlertController(title: "Change Email", message: "New Email", preferredStyle: .alert)
        //Add  three textfield to Alert
        alert.addTextField { (newEmailTF) in
            newEmailTF.placeholder = "new Email"

        }
        alert.addTextField { (currentEmailTF) in
            currentEmailTF.placeholder = "Current Email"
            
        }
        alert.addTextField { (passwordTF) in
            passwordTF.placeholder = "Password Email"
            passwordTF.isSecureTextEntry = true
            
        }
        // Add action for alert
        
        alert.addAction(UIAlertAction(title: "cancle", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
            if let textfiels = alert.textFields {
                
                let newEmail = textfiels[0].text!
                let currentEmail = textfiels[1].text!
                let password = textfiels[2].text!
                print(newEmail,currentEmail,password)
                user.updateEmail(to: newEmail, completion: { (error) in
                   if let errorUpdate = error {
                    print(errorUpdate)
                    //search for how to handel error code
                    //Requre recent Auth
                    
                     let  credential = EmailAuthProvider.credential(withEmail: currentEmail, password: password)
                    
                    user.reauthenticateAndRetrieveData(with: credential, completion: { (auth, error) in
                        //
                        if let error = error {
                            self.showAlert(title: "ReAuth-Message ", message: error.localizedDescription)
                        }else{
                            user.updateEmail(to: newEmail, completion: { (error) in
                                if let error = error {
                                    self.showAlert(title: "New Account Error", message: error.localizedDescription)
                                }else{
                                    self.showAlert(title: "New Account Success", message: "Email Update....!")
                                }
                            })
                        }
                    })
                    
                    // try with this
//                    user.reauthenticate(with: AuthCredential, completion: { (<#Error?#>) in
//                        <#code#>
//                    })
                    
       
                   }else{
                      self.showAlert(title: "Update Message", message: "Updating Successfully")                    }
                })
                
            }
                
            //print(newEmail,password,currentEmail)

        }))
        
        //Present Alert
        present(alert, animated: true, completion: nil)
    }
    
    

  
}
    
    

