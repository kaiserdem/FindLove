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

extension RegistrationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func handleSelectProfileImageView() {
    let picker = UIImagePickerController()
    
    picker.delegate = self
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    var selectedImageFromPicker: UIImage?
    if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      selectedImageFromPicker = editingImage
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      selectedImageFromPicker = originalImage
    }
    if let selectedImage = selectedImageFromPicker {
      userImageView.image = selectedImage
      userImageView.setNeedsDisplay()
    }
    
    dismiss(animated: true, completion: nil) // выйти с контроллера
    
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print("canceled picker")
    dismiss(animated: true, completion: nil)
  }
}
