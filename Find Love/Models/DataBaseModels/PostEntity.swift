//
//  PostEntity.swift
//  Find Love
//
//  Created by Kaiserdem on 16.06.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation
import CoreData

class PostEntity: NSManagedObject {
  
  // throws - функция может возвращать ощибки
  class func findeOrCreate(_ post: Post, context: NSManagedObjectContext) throws -> PostEntity {
    
     // перед тем как создать обьект нужно убедиться что его нет в базе
    let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
    // по какому критерию ищем обьект
    request.predicate = NSPredicate(format: "postId == %d",  post.postId! as CVarArg)
    
    do {
      let fetchResult = try context.fetch(request)
      
      // случай - дубликаты в базе данных, если проверка прошла успешно тогда возвращаем результат
      if fetchResult.count > 0 {
        assert(fetchResult.count == 1, "Duplicate has been found in DB")
        return fetchResult[0]
      }
    } catch {
      throw error
    }
    // создаем елемент в базе
    let postEntity = PostEntity(context: context)
    postEntity.postId = post.postId
    postEntity.fromId = post.fromId
    postEntity.text = post.text
    postEntity.timestamp = post.timestamp as! Int64
    postEntity.likedCount = post.likedCount ?? 0

    return postEntity
  }
  
  class func all(_ context: NSManagedObjectContext) throws -> [PostEntity]{
  
       let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
       
       do {
         return try context.fetch(request)
       } catch {
         throw error
       }
  }
}
