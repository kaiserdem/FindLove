//
//  Post.swift
//  Find Love
//
//  Created by Kaiserdem on 04.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import FirebaseAuth

class Post: NSObject { // модель сообщений
  
  var postId: String?
  var fromId: String?
  var text: String?
  var timestamp: NSNumber?
  var likedCount: Int?
  
  init(dictionary: [String: Any]) {
    self.postId = dictionary["postId"] as? String
    self.fromId = dictionary["fromId"] as? String
    self.text = dictionary["text"] as? String
    self.timestamp = dictionary["timestamp"] as? NSNumber
    self.likedCount = dictionary["likedCount"] as? Int
  }
}
