//
//  Extension.swift
//  Find Love
//
//  Created by Kaiserdem on 26.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import Foundation
import UIKit

let imageCach = NSCache<AnyObject, AnyObject>()

extension UIImageView {
  // загрузка картинки с кеша 
  func loadImageUsingCachWithUrlString(_ urlString: String) {
    self.image = nil // по дефолту
    // если есть такая картинка тогда загружаем из кеша
    if let cachedImage = imageCach.object(forKey: urlString as AnyObject) as? UIImage {
      self.image = cachedImage
      return
    }
    // в противном случае берем из интернета
    let url = URL(string: urlString)
    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
      
      if error != nil {
        print(error ?? "")
        return
      }
      DispatchQueue.main.async(execute: {
        if let downloadedImage = UIImage(data: data!) { // загруженое изображение
          imageCach.setObject(downloadedImage, forKey: urlString as AnyObject)
          
          self.image = downloadedImage
        }
      })
    }).resume()
  }
}

