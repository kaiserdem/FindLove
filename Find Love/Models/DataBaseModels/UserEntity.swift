//
//  UserEntity.swift
//  Find Love
//
//  Created by Kaiserdem on 06.06.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation
import CoreData

class UserEntity: NSManagedObject {
  
  // throws - функция может возвращать ощибки
  class func findeOrCreate(_ user: User, context: NSManagedObjectContext) throws -> UserEntity {
    
     // перед тем как создать обьект нужно убедиться что его нет в базе
    let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
    // по какому критерию ищем обьект
    request.predicate = NSPredicate(format: "id == %d",  user.id! as CVarArg)
    
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
    let userEntity = UserEntity(context: context)
    userEntity.id = user.id
    userEntity.name = user.name
    userEntity.email = user.email
    userEntity.profileImageUrl = user.profileImageUrl

    return userEntity
  }
  
  class func all(_ context: NSManagedObjectContext) throws -> [UserEntity]{
  
       let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
       
       do {
         return try context.fetch(request)
       } catch {
         throw error
       }
  }
}
