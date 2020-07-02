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
  
  
  weak var menuVC: ProfileVC?
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()

      navigationController?.navigationBar.isHidden = true
    
    checkAuth()    
  }
  
  private func checkAuth() {
    
    if Auth.auth().currentUser == nil {
      perform(#selector(handleLogin), with: nil, afterDelay: 0)
    } else {
      AuthManager.shared.loadFeedVC()
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
    let vc = SingInVC.init(nibName: "SingInVC", bundle: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func registrationBtnAction(_ sender: Any) {
    let vc = RegistrationVC.init(nibName: "RegistrationVC", bundle: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
