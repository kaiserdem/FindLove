//
//  HelloVC.swift
//  Find Love
//
//  Created by Kaiserdem on 24.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class HelloVC: UIViewController {

  @IBOutlet weak var singInBtn: UIButton!
  @IBOutlet weak var registrationBtn: UIButton!
  
  
  weak var menuVC: MenuVC?
  
  override func viewDidLoad() {
        super.viewDidLoad()

      navigationController?.navigationBar.isHidden = true
    
    checkAuth()
  }
  
  private func checkAuth() {
    
    if Auth.auth().currentUser == nil {
      perform(#selector(handleLogin), with: nil, afterDelay: 0)
    } else {
      let controll = MenuVC.init(nibName: "MenuVC", bundle: nil)
      navigationController?.pushViewController(controll, animated: true)
    }
  }
  
  @objc func handleLogin() {
    do {
      try Auth.auth().signOut()
    } catch let logoutError {
      print(logoutError)
    }
  }

  @IBAction func singInBtnAction(_ sender: Any) {
    let controll = SingInVC.init(nibName: "SingInVC", bundle: nil)
    navigationController?.pushViewController(controll, animated: true)
  }
  
  @IBAction func registrationBtnAction(_ sender: Any) {
    let controll = RegistrationVC.init(nibName: "RegistrationVC", bundle: nil)
    navigationController?.pushViewController(controll, animated: true)
  }
}
