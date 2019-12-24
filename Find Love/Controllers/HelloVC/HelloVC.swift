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
  
  override func viewDidLoad() {
        super.viewDidLoad()

      navigationController?.navigationBar.isHidden = true
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
