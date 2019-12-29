//
//  Message.swift
//  Find Love
//
//  Created by Kaiserdem on 26.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import FirebaseAuth

class Message: NSObject { // модель сообщений
  
  var fromId: String?
  var text: String?
  var timestamp: NSNumber?
  var toId: String?
  
  init(dictionary: [String: Any]) {
    self.fromId = dictionary["fromId"] as? String
    self.text = dictionary["text"] as? String
    self.toId = dictionary["toId"] as? String
    self.timestamp = dictionary["timestamp"] as? NSNumber
  }
  func chatPartnerId() -> String? { // если написали сообщение себе
    // если отправитель это я, тогда возврат toId, в противном случае fromId
    return fromId == Auth.auth().currentUser?.uid ? toId : fromId
  }
}
