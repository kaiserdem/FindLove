//
//  CoreDataManager.swift
//  Find Love
//
//  Created by Kaiserdem on 06.06.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
  
  static let shared = CoreDataManager()
  
   lazy var persistentContainer: NSPersistentContainer = {
       
       let container = NSPersistentContainer(name: "DataModel")
       container.loadPersistentStores(completionHandler: { (storeDescription, error) in
           if let error = error as NSError? {
              
               fatalError("Unresolved error \(error), \(error.userInfo)")
           }
       })
       return container
   }()

  private init() { }
  
  // запрос данных из базы данных
  func getAllUsers(_ completionHandler: @escaping ([User]) -> Void) {
    
    let viewContext = persistentContainer.viewContext
    
    viewContext.perform {
      
      let userEntities = try? UserEntity.all(viewContext)
    
      let dbUsers = userEntities?.map({User(entity: $0)})
      
      completionHandler(dbUsers ?? [])
    }
  }
  
  func getAllPosts(_ completionHandler: @escaping ([Post]) -> Void) {
    
    let viewContext = persistentContainer.viewContext
    
    viewContext.perform {
      
      let postEntities = try? PostEntity.all(viewContext)
    
      let dbPosts = postEntities?.map({Post(entity: $0)})
      
      completionHandler(dbPosts ?? [])
    }
  }
  
  func saveUsers(users:[User], completionHandler: @escaping() -> Void) {
    
    let viewContext = persistentContainer.viewContext
    
    viewContext.perform {
      for user in users {
        _ = try? UserEntity.findeOrCreate(user, context: viewContext)
      }
      try? viewContext.save()
      completionHandler()
    }
  }
  
  func savePosts(posts:[Post], completionHandler: @escaping() -> Void) {
    
    let viewContext = persistentContainer.viewContext
    
    viewContext.perform {
      for post in posts {
        _ = try? PostEntity.findeOrCreate(post, context: viewContext)
      }
      try? viewContext.save()
      completionHandler()
    }
  }
}

