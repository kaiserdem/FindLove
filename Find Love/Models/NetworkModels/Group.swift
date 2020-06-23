//
//  Group.swift
//  Find Love
//
//  Created by Kaiserdem on 13.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation

class Group: NSObject {
  
  var subject: String?
  var descriptions: String?
  var iconImageUrl: String?
  var countUsers: Int64?
  var liked: Int64?
  
  
  init(dictionary: [String: Any]) {
    self.subject = dictionary["subject"] as? String
    self.descriptions = dictionary["descriptions"] as? String
    self.iconImageUrl = dictionary["iconImageUrl"] as? String
    self.countUsers = dictionary["countUsers"] as? Int64
    self.liked = dictionary["liked"] as? Int64
  }
  
  init(entity: GroupEntity) {
    self.subject = entity.subject
    self.descriptions = entity.descriptions
    self.iconImageUrl = entity.iconImageUrl
    self.countUsers = Int64(entity.countUsers)
    self.liked = Int64(entity.liked)
  }
}
