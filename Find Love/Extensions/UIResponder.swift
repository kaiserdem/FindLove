//
//  extension.swift
//  Find Love
//
//  Created by Kaiserdem on 04.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation

import UIKit

extension UIResponder {
  
  func setFormatDislayedTimeAndDate(from interval : TimeInterval, withString: Bool) -> String {
    let calendar = Calendar.current
    let date = Date(timeIntervalSince1970: interval)
    
    let dateFormatterHM = DateFormatter()
    dateFormatterHM.dateFormat = "hh:mm"
    
    let dateFormatterMDHM = DateFormatter()
    dateFormatterMDHM.dateFormat = "MM-dd hh:mm" //"YYYY-MM-dd hh:mm"
    
    if withString == true {
      if calendar.isDateInYesterday(date) { return "Вчера \(dateFormatterHM.string(from: date))" }
      else if calendar.isDateInToday(date) { return "Сегодня \(dateFormatterHM.string(from: date))" }
      else {
        return dateFormatterMDHM.string(from: date)
      }
    } else {
      if calendar.isDateInYesterday(date) { return "\(dateFormatterHM.string(from: date))" }
      else if calendar.isDateInToday(date) { return "\(dateFormatterHM.string(from: date))" }
      else {
        return dateFormatterMDHM.string(from: date)
      }
    }
  }
}


extension UIResponder {
  
  // принимает текст возвращает размер
  func estimateFrameForText(_ text: String) -> CGRect {
    
    let size = CGSize(width: 200, height: 1000)
    
    // текст прислоняеться к левому краю и использует пренос строки
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
}

extension UIResponder {
  
  func statusOnlineValidator(string: String) -> String {
    if string == "0" {
      return ""
    } else {
      return "Онлайн"
    }
  }
  
  func genderValidatorToText(string: String) -> String {
    if string == "1" {
      return "Мужской"
    } else {
      return "Женский"
    }
  }
  
  func messageStatusValidator(_ string: String) -> String {
    if string == "1" {
      return "Запрос на открытие личного чата."
    } else if string == "2" {
      return "Ответ на пост:"
    } else {
      return ""
    }
  }
  
  func orientationValidatorToText(string: String) -> String {
    if string == "1" {
      return "Девушки"
    } else if string == "2" {
      return "Парни"
    } else {
      return "Девушки и парни"
    }
  }
  
  func genderValidatorToIndex(string: String) -> String {
    if string == "Мужской" {
      return "1"
    } else {
      return "2"
    }
  }
  
  func orientationValidatorToIndex(string: String) -> String {
    if string == "Девушки" {
      return "1"
    } else if string == "Парни" {
      return "2"
    } else {
      return "3"
    }
  }
}
