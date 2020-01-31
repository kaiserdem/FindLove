//
//  User.swift
//  Find Love
//
//  Created by Kaiserdem on 26.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import Foundation

//enum Gender: String {
//  case Male, Female
//  func validator() -> String {
//    switch self {
//    case .Male:
//      return "Мужчина"
//    case .Female:
//      return "Женщина"
//    }
//  }
//}
//
//enum Orientation: String {
//  case Man, Woman, Multy
//  func validator() -> String {
//    switch self {
//    case .Man:
//      return "Парни"
//    case .Woman:
//      return "Девушки"
//    case .Multy:
//      return "Девушки и парни"
//    }
//  }
//}
//

class User: NSObject {
  
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
