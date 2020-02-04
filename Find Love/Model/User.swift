//
//  User.swift
//  Find Love
//
//  Created by Kaiserdem on 26.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import Foundation


class User: NSObject, Codable {
  
  var id: String?
  var name: String?
  var email: String?
  var profileImageUrl: String?
  var age: Int?
  var status: String?
  var aboutSelf: String?
  var orientation: String?
  var gender: String?
  
  
  init(dictionary: [String: AnyObject]) {
    self.id = dictionary["id"] as? String
    self.name = dictionary["name"] as? String
    self.email = dictionary["email"] as? String
    self.profileImageUrl = dictionary["profileImageUrl"] as? String
    self.age = dictionary["age"] as? Int
    self.status = dictionary["status"] as? String
    self.aboutSelf = dictionary["aboutSelf"] as? String
    self.gender = dictionary["gender"] as? String
    self.orientation = dictionary["orientation"] as? String
  }
}
