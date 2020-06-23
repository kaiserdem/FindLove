//
//  GroupEntity.swift
//  Find Love
//
//  Created by Kaiserdem on 18.06.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation
import CoreData

class GroupEntity: NSManagedObject {
  
  // throws - функция может возвращать ощибки
  class func findeOrCreate(_ group: Group, context: NSManagedObjectContext) throws -> GroupEntity {
    
     // перед тем как создать обьект нужно убедиться что его нет в базе
    let request: NSFetchRequest<GroupEntity> = GroupEntity.fetchRequest()
    // по какому критерию ищем обьект
    request.predicate = NSPredicate(format: "subject == %d",  group.subject! as CVarArg)
    
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
    let groupEntity = GroupEntity(context: context)
    groupEntity.subject = group.subject
    groupEntity.descriptions = group.descriptions
    groupEntity.iconImageUrl = group.iconImageUrl
    groupEntity.countUsers = group.countUsers ?? 0
    groupEntity.liked = group.liked ?? 0

    return groupEntity
  }
  
  class func all(_ context: NSManagedObjectContext) throws -> [GroupEntity]{
  
       let request: NSFetchRequest<GroupEntity> = GroupEntity.fetchRequest()
       
       do {
         return try context.fetch(request)
       } catch {
         throw error
       }
  }
 
}
