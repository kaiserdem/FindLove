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

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var closeBtnTopConstraints: NSLayoutConstraint!
  @IBOutlet weak var closeBtn: UIButton!
  @IBOutlet weak var forgotPasswordBtn: UIButton!
  @IBOutlet weak var passwordTF: UITextField!
  
  weak var menuVC: ProfileVC?
  
  @IBOutlet weak var enterBtn: UIButton!
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    activityIndicator.isHidden = true
      
      navigationController?.navigationBar.isHidden = true

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide(sender:))))
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func keyboardWillShow(sender: NSNotification) {
    print("keyboardWillShow")
    self.view.frame.origin.y = -100
    closeBtnTopConstraints.constant = 130
  }
  
  @objc func keyboardWillHide(sender: NSNotification) {
    print("keyboardWillHide")
    self.view.frame.origin.y = 0
    closeBtnTopConstraints.constant = 30
    view.endEditing(true)
  }
  
    func handleLogin() {
      guard let email = emailTF.text, let password = passwordTF.text else {
        print("Form is not valid")
        return
      }
      Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
        if error != nil {
          print("Error sing in")
          self?.view.endEditing(true)
          self?.activityIndicator.stopAnimating()
          self?.activityIndicator.isHidden = true
          
          let view = CustomAlertWarning(frame: (self?.view.frame)!)
          view.textTextView.text = "Не верный логин или пароль "
          self?.view.addSubview(view)
          return
        }
        
        print("Success sing in")
        self?.activityIndicator.stopAnimating()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        _ = appDelegate.checkIfUserIsLogedIn()
      }
    }

  @IBAction func enterBtnAction(_ sender: Any) {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    handleLogin()
    view.endEditing(true)
  }
  @IBAction func forgotPasswordBtnAction(_ sender: Any) {
    
  }
  @IBAction func closeBtnAction(_ sender: Any) {
    let vc = HelloVC.init(nibName: "HelloVC", bundle: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
