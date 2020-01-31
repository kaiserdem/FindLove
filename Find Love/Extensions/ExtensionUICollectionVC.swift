//
//  ExtensionUICollectionVC.swift
//  Find Love
//
//  Created by Kaiserdem on 26.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

extension UIResponder {
  
  // принимает текст возвращает размер
  func estimateFrameForText(_ text: String) -> CGRect {
    
    let size = CGSize(width: 200, height: 1000)
    
    // текст прислоняеться к левому краю и использует пренос строки
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
}

