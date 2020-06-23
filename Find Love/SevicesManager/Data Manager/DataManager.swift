//
//  DataManager.swift
//  Find Love
//
//  Created by Kaiserdem on 06.06.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation
import Firebase

class DataManager {
  
  let coreDataManager = CoreDataManager.shared
  let networkManager = NetworkManager()
  
  func getUsersCDorFB(_ comletionHandeler: @escaping ([User]) -> Void) {
    
    coreDataManager.getAllUsers { [weak self] (users) in
      if users.count > 0 {
        print("Users from Core Data")
        comletionHandeler(users)
        
      } else {
        
        self?.networkManager.getUsers { [weak self] (users:[User]) in
          print("Users from Network")
          self?.coreDataManager.saveUsers(users: users) {
            comletionHandeler(users)
          }
        }
      }
    }
  }
  
  func getPostsCDorFB(_ comletionHandeler: @escaping ([Post]) -> Void) {
    
    coreDataManager.getAllPosts { [weak self] (posts) in
      if posts.count > 0 {
        print("Posts from Core Data")
        comletionHandeler(posts)
        
      } else {
        
        self?.networkManager.getPosts { [weak self] (posts:[Post]) in
          print("Posts from Network")
          self?.coreDataManager.savePosts(posts: posts) {
            comletionHandeler(posts)
          }
        }
      }
    }
  }
  
  func getGroupsCDorFB(_ comletionHandeler: @escaping ([Group]) -> Void) {
    
//    coreDataManager.getAllGroups { [weak self] (groups) in
//      if users.count > 0 {
//        print("Groups from Core Data")
//        comletionHandeler(groups)
//
//      } else {
//
//        self?.networkManager.getGroups { [weak self] (users:[User]) in
//          print("Groups from Network")
//          self?.coreDataManager.saveUsers(users: groups) {
//            comletionHandeler(groups)
//          }
//        }
//      }
//    }
  }
}



/*
 // спрашивает кор дату за наличие данных,если таких нет - тогда скачиваем из интернета
 func getAllUsers(_ comletionHandeler: @escaping ([User]) -> Void) {
   
   coreDataManager.getAllUsers { (users) in
     
     if users.count > 0 {
       print("from data base")
       comletionHandeler(users)
       
     } else {
       
       self.networkManager.getAll(.users) { (users:[User]) in
         self.coreDataManager.save(users: users) {
           comletionHandeler(users)
         }
       }
     }
   }
 }
 */






//        var users = [User]()
//             let ref = Database.database().reference().child("users")
//
//        ref.observe(.childAdded) { (snapshot) in
//          if let dictionary = snapshot.value as? [String: AnyObject] {
//
//            let user = User(dictionary: dictionary)
//            users.append(user)
//
//          }
//          self.coreDataManager.save(users: users) {
//            comletionHandeler(users)
//          }
//        }
