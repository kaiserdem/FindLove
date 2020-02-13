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
  
  var response: String?
  var fromId: String?
  var text: String?
  var timestamp: NSNumber?
  var toId: String?
  var responseToText: String?
  var stausMessage: String?
  
  var videoUrl: String?
  var imageUrl: String?
  var imageWidth: Float?
  var imageHeight: Float?
  
  init(dictionary: [String: Any]) {
    self.fromId = dictionary["fromId"] as? String
    self.text = dictionary["text"] as? String
    self.toId = dictionary["toId"] as? String
    self.timestamp = dictionary["timestamp"] as? NSNumber
    self.imageUrl = dictionary["imageUrl"] as? String
    self.imageWidth = dictionary["imageWidth"] as? Float
    self.imageHeight = dictionary["imageHeight"] as? Float
    self.videoUrl = dictionary["videoUrl"] as? String
    self.responseToText = dictionary["responseToText"] as? String
    self.stausMessage = dictionary["stausMessage"] as? String
  }
  func chatPartnerId() -> String? { // если написали сообщение себе
    // если отправитель это я, тогда возврат toId, в противном случае fromId
    return fromId == Auth.auth().currentUser?.uid ? toId : fromId
  }
}
