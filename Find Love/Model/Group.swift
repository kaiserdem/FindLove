//
//  Group.swift
//  Find Love
//
//  Created by Kaiserdem on 13.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import FirebaseAuth

class Group: NSObject {
  
  var subject: String?
  var descriptions: String?
  var iconImageUrl: String?
  var countUsers: Int?
  var liked: Int?
  
  
  init(dictionary: [String: Any]) {
    self.subject = dictionary["subject"] as? String
    self.descriptions = dictionary["descriptions"] as? String
    self.iconImageUrl = dictionary["iconImageUrl"] as? String
    self.countUsers = dictionary["countUsers"] as? Int
    self.liked = dictionary["liked"] as? Int
    
  }
}
