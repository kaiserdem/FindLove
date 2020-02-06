//
//  ExtensionAlertController.swift
//  Find Love
//
//  Created by Kaiserdem on 31.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
  
  func postAlert(_ title: String) {
    
    DispatchQueue.main.async(execute: { () -> Void in
      
      let alert = UIAlertController(title: title, message: nil,
                                    preferredStyle: UIAlertController.Style.alert)
      
      alert.addAction(UIAlertAction(title: "Да", style: .cancel, handler: { (action: UIAlertAction!) in
        do {
          try Auth.auth().signOut()
        } catch let logoutError {
          print(logoutError)
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        _ = appDelegate.loadHelloVC()
      }))
      
      alert.addAction(UIAlertAction(title: "Отменить", style: UIAlertAction.Style.default, handler: nil))
      
      let popOver = alert.popoverPresentationController
      popOver?.sourceView  = self.view
      popOver?.sourceRect = self.view.bounds
      popOver?.permittedArrowDirections = UIPopoverArrowDirection.any
      
      self.present(alert, animated: true, completion: nil)
      
    })
    
  }
}
