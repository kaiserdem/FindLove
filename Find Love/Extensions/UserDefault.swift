//
//  UserDefault.swift
//  Find Love
//
//  Created by Kaiserdem on 04.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation

extension UserDefaults {
  
  func save<T: Codable>(_ object: T, forKey key: String) {
    let encoder = JSONEncoder()
    if let encodedObject = try? encoder.encode(object) {
      UserDefaults.standard.set(encodedObject, forKey: key)
      UserDefaults.standard.synchronize()
    }
  }
  
  func getObject<T: Codable>(forKey key: String) -> T? {
    if let object = UserDefaults.standard.object(forKey: key) as? Data {
      let decoder = JSONDecoder()
      if let decodedObject = try? decoder.decode(T.self, from: object) {
        return decodedObject
      }
    }
    return nil
  }
  
//  func save<T:Encodable>(customObject object: T, inKey key: String) {
//    let encoder = JSONEncoder()
//    if let encoded = try? encoder.encode(object) {
//      self.set(encoded, forKey: key)
//    }
//  }
  
  func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
    if let data = self.data(forKey: key) {
      let decoder = JSONDecoder()
      if let object = try? decoder.decode(type, from: data) {
        return object
      }else {
        print("Couldnt decode object")
        return nil
      }
    }else {
      print("Couldnt find key")
      return nil
    }
  }
}
