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
  @IBOutlet weak var closeBtnTopConstraints: NSLayoutConstraint!
  @IBOutlet weak var closeBtn: UIButton!
  @IBOutlet weak var forgotPasswordBtn: UIButton!
  @IBOutlet weak var passwordTF: UITextField!
  
  weak var menuVC: MenuVC?
  
  @IBOutlet weak var enterBtn: UIButton!
  override func viewDidLoad() {
        super.viewDidLoad()
      
      navigationController?.navigationBar.isHidden = true

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
  }
  
  @objc func keyboardWillShow(sender: NSNotification) {
    self.view.frame.origin.y = -100 // Move view 150 points upward
    closeBtnTopConstraints.constant = 130
  }
  
  @objc func keyboardWillHide(sender: NSNotification) {
    self.view.frame.origin.y = 0 // Move view to original position
    closeBtnTopConstraints.constant = 30
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
        
        print("Success sing in")
        self.menuVC?.fetchUserAndSetupNavBarTitle()
        let vc = MenuVC.init(nibName: "MenuVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }

  @IBAction func enterBtnAction(_ sender: Any) {
    handleLogin()
  }
  @IBAction func forgotPasswordBtnAction(_ sender: Any) {
    
  }
  @IBAction func closeBtnAction(_ sender: Any) {
    let vc = HelloVC.init(nibName: "HelloVC", bundle: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
