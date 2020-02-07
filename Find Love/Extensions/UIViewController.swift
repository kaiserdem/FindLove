//
//  ExtensionAlertController.swift
//  Find Love
//
//  Created by Kaiserdem on 31.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func showAlert(title: String!, success: (() -> Void)? , cancel: (() -> Void)?) {
    
    DispatchQueue.main.async(execute: { [weak self] () -> Void in
      
      let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
      
      let successAction: UIAlertAction = UIAlertAction(title: "Да", style: .default) {
        action -> Void in success?()
      }
      let cancelAction: UIAlertAction = UIAlertAction(title: "Отменить", style: .cancel) {
        action -> Void in cancel?()
      }
      
      alertController.addAction(successAction)
      alertController.addAction(cancelAction)
      self?.present(alertController, animated: true, completion: nil)
    })
  }
}
