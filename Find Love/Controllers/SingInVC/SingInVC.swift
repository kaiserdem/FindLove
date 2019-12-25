//
//  SingInVC.swift
//  Find Love
//
//  Created by Kaiserdem on 24.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class SingInVC: UIViewController {

  @IBOutlet weak var emailTF: UITextField!
  
  @IBOutlet weak var forgotPasswordBtn: UIButton!
  @IBOutlet weak var passwordTF: UITextField!
  
  @IBOutlet weak var enterBtn: UIButton!
  override func viewDidLoad() {
        super.viewDidLoad()
      
      navigationController?.navigationBar.isHidden = true

  }
  
    func handleLogin() {
      guard let email = emailTF.text, let password = passwordTF.text else {
        print("Form is not valid")
        return
      }
      Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
        if error != nil {
          print("Error sing in")
          return
        }
        
        // польучить пользователи и настройки  нав бара и тутула
        //self.messagesController?.fetchUserAndSetupNavBarTitle()
        print("Success sing in")
        let controll = MenuVC.init(nibName: "MenuVC", bundle: nil)
        self.navigationController?.pushViewController(controll, animated: true)
      }
    }

  @IBAction func enterBtnAction(_ sender: Any) {
    handleLogin()
  }
  @IBAction func forgotPasswordBtnAction(_ sender: Any) {
    
  }
  @IBAction func closeBtnAction(_ sender: Any) {
    let controll = HelloVC.init(nibName: "HelloVC", bundle: nil)
    navigationController?.pushViewController(controll, animated: true)
  }
  
}
