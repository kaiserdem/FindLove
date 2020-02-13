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

extension UICollectionViewController {
  
  func showAlertMulty(choiceWriteAction: (() -> Void)? ,choiceOpenProfile: (() -> Void)? ,choiceInviteChat: (() -> Void)? ,choiceComplain: (() -> Void)? ,choiceBlockUser: (() -> Void)? ,cancel: (() -> Void)?) {
    
    DispatchQueue.main.async(execute: { [weak self] () -> Void in
      
      let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
      
      let writeAction: UIAlertAction = UIAlertAction(title: "Познакомиться", style: .default) {
        action -> Void in choiceWriteAction?()
      }
      let openProfileAction: UIAlertAction = UIAlertAction(title: "Посмотреть профиль", style: .default) {
        action -> Void in choiceOpenProfile?()
      }
      let inviteChatAction: UIAlertAction = UIAlertAction(title: "Пригласить в другой чат", style: .default) {
        action -> Void in choiceInviteChat?()
      }
      let complainAction: UIAlertAction = UIAlertAction(title: "Пожаловаться", style: .default) {
        action -> Void in choiceComplain?()
      }
      let blockUserAction: UIAlertAction = UIAlertAction(title: "Заблокировать", style: .default) {
        action -> Void in choiceBlockUser?()
      }
      let cancelAction: UIAlertAction = UIAlertAction(title: "Отменить", style: .cancel) {
        action -> Void in cancel?()
      }
      alertController.addAction(writeAction)
      alertController.addAction(openProfileAction)
      alertController.addAction(inviteChatAction)
      alertController.addAction(complainAction)
      alertController.addAction(blockUserAction)
      alertController.addAction(cancelAction)
      self?.present(alertController, animated: true, completion: nil)
    })
  }
}
