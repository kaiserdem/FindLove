//
//  ChatLogVC.swift
//  Find Love
//
//  Created by Kaiserdem on 27.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit

class ChatLogVC: UIViewController, UITextFieldDelegate {
  
  var user: User? {
    didSet {
      navigationItem.title = user?.name
      
      //observeMessages() // наблюдать сообщения по Id
    }
  }
  
  var messages = [Message]() // масив всех сообщений
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}
