//
//  User.swift
//  Find Love
//
//  Created by Kaiserdem on 26.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import Foundation

class User: NSObject {
  
  var id: String?
  var name: String?
  var email: String?
  var profileImageUrl: String?
  
  init(dictionary: [String: AnyObject]) {
    self.id = dictionary["id"] as? String
    self.name = dictionary["name"] as? String
    self.email = dictionary["email"] as? String
    self.profileImageUrl = dictionary["profileImageUrl"] as? String
    
  }
}
