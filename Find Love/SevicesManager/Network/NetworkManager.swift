//
//  NetworkManager.swift
//  Find Love
//
//  Created by Kaiserdem on 06.06.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation
import Firebase

let refDataBase = Database.database().reference()

class NetworkManager {
  
  static let shared = NetworkManager()
    
  init() { return }
  
  var initialRead = true

  func getUsers(_ comletionHandeler: @escaping ([User]) -> Void) {
    let usersRef = refDataBase.child(RequestType.users.endPoint)
    
      var users = [User]()
      usersRef.observe(.childAdded, with: { [weak self] snapshot in
        
          if let dictionary = snapshot.value as? [String: AnyObject] {
            let user = User(dictionary: dictionary)
            user.id = snapshot.key
            users.append(user)
          }

          if self?.initialRead == false {
              print("a new user was added")
          }
      })

      usersRef.observeSingleEvent(of: .value, with: { [weak self] snapshot in
          print("--inital load has completed and the last user was read--")
        comletionHandeler(users)
          self?.initialRead = false
      })
  }
  
  
func getPosts(_ comletionHandeler: @escaping ([Post]) -> Void) {
     let postsRef = refDataBase.child(RequestType.posts.endPoint)

    var posts = [Post]()
    postsRef.observe(.childAdded, with: { [weak self] snapshot in
      
        if let dictionary = snapshot.value as? [String: AnyObject] {
          let post = Post(dictionary: dictionary)
          posts.append(post)
        }

        if self?.initialRead == false {
            print("a new post was added")
        }
    })

    postsRef.observeSingleEvent(of: .value, with: { [weak self] snapshot in
        print("--inital load has completed and the last post was read--")
      comletionHandeler(posts)
        self?.initialRead = false
    })
  }
  
  func getGroups(_ comletionHandeler: @escaping ([Group]) -> Void) {
     let groupsRef = refDataBase.child(RequestType.groups.endPoint)

    var groups = [Group]()
    groupsRef.observe(.childAdded, with: { [weak self] snapshot in

        if let dictionary = snapshot.value as? [String: AnyObject] {
          let group = Group(dictionary: dictionary)
          groups.append(group)
        }

        if self?.initialRead == false {
            print("a new group was added")
        }
    })

    groupsRef.observeSingleEvent(of: .value, with: { [weak self] snapshot in
        print("--inital load has completed and the last group was read--")
      comletionHandeler(groups)
        self?.initialRead = false
    })
  }
  
}


/*
 func getAllUsersFB(_ comletionHandeler: @escaping ([User]) -> Void) {
   let ref = Database.database().reference().child("users")
   var users = [User]()
   ref.observe(.childAdded) { (snapshot) in
     if let dictionary = snapshot.value as? [String: AnyObject] {
       
       let user = User(dictionary: dictionary)
       users.append(user)
     }
   }
   comletionHandeler(users)
 }
 */
  
  /*
  func getComplimentsReceived(forUserId forId: String, handler: @escaping (_ complimentPack: [Any] ,_ success: Bool) -> ()){
      REF_USERS_COMPLIMENTS.child(forId).observe(.value) { (snapshot) in
          var compliments = [Any]()//empty array to hold compliments
          let dispatchGroup = DispatchGroup()
          for item in snapshot.children {

              for (key, status) in dict {

                  switch status {
                      case true:
                          dispatchGroup.enter()
                          self.REF_USERS.child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                              // ...
                              compliments.append(complimentPack)
                              dispatchGroup.leave()
                      })//end observer
                      case false:
                          print(status)
                          break

                  }//end switch

              }//end for dict

          } //end for snapshot.item

          dispatchGroup.notify(queue: .main) {
              handler(compliments, true)
          }
      } //end observe

  }//end func
  
  */
  
