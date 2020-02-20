//
//  Request.swift
//  Find Love
//
//  Created by Kaiserdem on 20.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import FirebaseAuth

class Request: NSObject { // модель сообщений
  
  var fromUser: String?
  var fromImageUrl: String?
  var fromUserId: String?
  var toId: String?
  var toGroup: String?
  var statusRequest: String?
  
  init(dictionary: [String: Any]) {
    self.fromUser = dictionary["fromUser"] as? String
    self.fromImageUrl = dictionary["fromImageUrl"] as? String
    self.fromUserId = dictionary["fromUserId"] as? String
    self.toId = dictionary["toId"] as? String
    self.toGroup = dictionary["toGroup"] as? String
    self.statusRequest = dictionary["statusRequest"] as? String
    
  }
}
