//
//  MenuVC.swift
//  Find Love
//
//  Created by Kaiserdem on 24.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class MenuVC: UIViewController {

  @IBOutlet weak var logoutBtn: UIButton!
  
  override func viewDidLoad() {
        super.viewDidLoad()


  }


  
  @IBAction func logoutBtnAction(_ sender: Any) {
    do {
      try Auth.auth().signOut()
    } catch let logoutError {
      print(logoutError)
    }
    let controll = HelloVC.init(nibName: "HelloVC", bundle: nil)
    self.navigationController?.pushViewController(controll, animated: true)
  }
  
}
