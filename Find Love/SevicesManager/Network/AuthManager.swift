//
//  AuthManager.swift
//  Find Love
//
//  Created by Kaiserdem on 19.06.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation
import Firebase

class AuthManager {
  
  static let shared = AuthManager()
    
  init() { return }
  
  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  let dataBaseRef = Database.database().reference()
  let storageRef = Storage.storage().reference()
  
  func checkIfUserIsLogedIn() { // проверка если пользователь вошел в систему
    if Auth.auth().currentUser?.uid == nil { // если мы не вошли
      loadHelloVC()
    } else {
      loadFeedVC()
      reloadOnlineStatus(isOnline: true)
    }
  }
  
  func loadHelloVC() {
    let nav1 = UINavigationController()
    let mainView = HelloVC(nibName: "HelloVC", bundle: nil)
    nav1.viewControllers = [mainView]
    
    appDelegate.window!.rootViewController = nav1
    appDelegate.window?.makeKeyAndVisible()
  }
  
  func loadFeedVC() {
    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "CustomTabBar") as UIViewController
    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
    appDelegate.window?.rootViewController = initialViewControlleripad
    appDelegate.window?.makeKeyAndVisible()
  }
  
  func reloadOnlineStatus(isOnline online: Bool) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let ref = Database.database().reference().child(RequestType.users.endPoint).child(uid)
    
    if online == true {
      let valuesStatus = ["statusOnline": "1"] as [String : Any]
      ref.updateChildValues(valuesStatus)
    } else {
      let valuesStatus = ["statusOnline": "0"] as [String : Any]
      ref.updateChildValues(valuesStatus)
    }
  }
  
  func userUID() -> String {
    let uid = Auth.auth().currentUser?.uid
    return uid!
  }
  
  func handleLogout() {
     do {
       try Auth.auth().signOut()
     } catch let logoutError {
       print(logoutError)
     }
     loadHelloVC()
   }
  
  func handleRegister(_ email: String, _ password: String, _ name: String, _ profileImage: UIImage) {
//    self.view.frame.origin.y = 0
//    guard let email = emailTF.text , let password = passwordTF.text, let name = nameTextField.text else { // если пустые, принт, выходим
//      print("Error: field is empty")
//
//      activityIndicator.isHidden = true
//      activityIndicator.stopAnimating()
//      return
//    }
//    view.endEditing(true)
//    if imageStatus == 0 {
//      self.view.frame.origin.y = 0
//      let view = CustomAlertWarning(frame: self.view.frame)
//      view.textTextView.text = "Без фотографии регистрация невозможна"
//      self.view.addSubview(view)
//      activityIndicator.isHidden = true
//      activityIndicator.stopAnimating()
//      return
//    }
    
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
      if error != nil { // если ошибка, принт, выходим
        print("Error")
//        self?.activityIndicator.isHidden = true
//        self?.activityIndicator.stopAnimating()
        return
      }
      // успешно
      
      guard let uid = user?.user.uid else { // создаем айди пользователя
        return
      }
      let imageName = NSUUID().uuidString // генерирует случайный айди
      // создали папку  для картинке в базе
      self?.storageRef.child("profile_images").child("\(imageName).png")
      
      let uploadData = profileImage.jpegData(compressionQuality: 0.1)
      
      self?.storageRef.putData(uploadData!, metadata: nil, completion: { [weak self] (metadata, error) in
          
          if error != nil {
            print(error ?? "")
            return
          }
          // могут быть ошибки
        self?.storageRef.downloadURL(completion: { [weak self] (url, error) in
            if error != nil {
              print(error!.localizedDescription)
              return
            }
            if let profileImageUrl = url?.absoluteString {
              
              let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
              self?.registeUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
            }
          })
        })
      }
    }
  
  func registeUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
     
    let userReference = dataBaseRef.child(RequestType.users.endPoint).child(uid) // создали папку пользователя
     userReference.updateChildValues(values, withCompletionBlock: { [weak self] (error, ref) in
       if error != nil {
         return
       }
//       self?.activityIndicator.isHidden = true
//       self?.activityIndicator.stopAnimating()
//
      self?.checkIfUserIsLogedIn()
     })
   }
}
