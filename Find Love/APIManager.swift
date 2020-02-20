//
//  APIManager.swift
//  Find Love
//
//  Created by Kaiserdem on 19.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

//import Firebase
//import FirebaseAuth
//import FirebaseDatabase
//
//class FirebaseAPI {
//  static let shared = FirebaseAPI()
//  
//   init() {}
  
  //Authentication
//  func logInUser(onCompletion: @escaping (String?) -> Void {
//    FIRAuth.auth().signInAnonymously(completion: {(user, error) in
//    if error == nil {
//    onCompletion(user!.uid)
//    } else {
//    onCompletion(nil)
//    }
//    })
//  }
  
  //Database
//  func getObjects(parameter: ParamaterClass, onCompletion: @escaping ([ObjectClass]) -> Void) {
//    Constants.Firebase.References.Object?.observe(.value, with: { snapshot in
//      var objects = [ObjectClass]()
//
//      if snapshot.exists() {
//        for child in snapshot.children.allObjects {
//          let object = Object(snapshot: child as! FIRDataSnapshot)
//          objects.append(object)
//        }
//      }
//      onCompletion(objects)
//    })
//  }
//}

//struct Constants {
//  struct Firebase {
//    static var CurrentUser: DatabaseReference?
//    static var Objects: DatabaseReference?
//  }
//}
