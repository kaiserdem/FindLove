//
//  PurchaseVC.swift
//  Find Love
//
//  Created by Kaiserdem on 10.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class PurchaseVC: UIViewController {

  let gradientLayer = CAGradientLayer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.isHidden = true

  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}

