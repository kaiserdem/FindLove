//
//  Post.swift
//  Find Love
//
//  Created by Kaiserdem on 04.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import FirebaseAuth

class Post: NSObject { // модель сообщений
  
  var fromId: String?
  var text: String?
  var timestamp: NSNumber?
  
  var videoUrl: String?
  var imageUrl: String?
  var imageWidth: Float?
  var imageHeight: Float?
  
  init(dictionary: [String: Any]) {
    self.fromId = dictionary["fromId"] as? String
    self.text = dictionary["text"] as? String
    self.timestamp = dictionary["timestamp"] as? NSNumber
    self.imageUrl = dictionary["imageUrl"] as? String
    self.imageWidth = dictionary["imageWidth"] as? Float
    self.imageHeight = dictionary["imageHeight"] as? Float
    self.videoUrl = dictionary["videoUrl"] as? String
  }
}