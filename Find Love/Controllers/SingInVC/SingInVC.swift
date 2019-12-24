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

    override func viewDidLoad() {
        super.viewDidLoad()
      
      navigationController?.navigationBar.isHidden = true


  }

  @IBAction func closeBtnAction(_ sender: Any) {
    let controll = HelloVC.init(nibName: "HelloVC", bundle: nil)
    navigationController?.pushViewController(controll, animated: true)
  }
  
}
