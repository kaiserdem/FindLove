//
//  RegistrationVC.swift
//  Find Love
//
//  Created by Kaiserdem on 24.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

// test1@gmail.com
import UIKit
import Firebase

class RegistrationVC: UIViewController {
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var setPhotoBtn: UIButton!
  @IBOutlet weak var findeAgeToTF: UITextField!
  @IBOutlet weak var findeAgeFromTF: UITextField!
  @IBOutlet weak var findGenderSegCont: UISegmentedControl!
  @IBOutlet weak var genderSegCont: UISegmentedControl!
  @IBOutlet weak var closeBtn: UIButton!
  @IBOutlet weak var registrationBtn: UIButton!
  @IBOutlet weak var ageTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      
        navigationController?.navigationBar.isHidden = true
    }


  func handleRegister() {
    guard let email = emailTF.text , let password = passwordTF.text, let name = nameTextField.text else { // если пустые, принт, выходим
      print("Error: field is empty")
      return
    }
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
      if error != nil { // если ошибка, принт, выходим
        print("Error")
        return
      }
      // успешно
      
      guard let uid = user?.user.uid else { // создаем айди пользователя
        return
      }
      
      let ref = Database.database().reference(fromURL: "https://findlove-f6445.firebaseio.com/")
      let userReference = ref.child("users").child(uid)
      let values = ["name": name, "email": email]
      userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
        if error != nil {
          print(error)
          return
        }
        print("Success register")
        let controll = MenuVC.init(nibName: "MenuVC", bundle: nil)
        self.navigationController?.pushViewController(controll, animated: true)
      })
    }
  }
  
//  func handleRegister() { // выполнит регистрацию
//    guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else { // если пустые, принт, выходим
//      print("Form is not valid")
//      return
//    }
//
//    Auth.auth().createUser(withEmail: email, password: password) { (user: AuthDataResult?, error) in
//      if error != nil { // если ошибка, принт, выходим
//        print(error ?? "")
//        return
//      }
//
//      guard let uid = user?.user.uid else { // создаем айди пользователя
//        return
//      }
//      let imageName = NSUUID().uuidString // генерирует случайный айди
//      // создали папку  для картинке в базе
//      let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
//
//
//      if let profileImage = self.profileImageView.image, let  uploadData = profileImage.jpegData(compressionQuality: 0.1) {
//        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//
//          if error != nil {
//            print(error ?? "")
//            return
//          }
//          // могут быть ошибки
//          storageRef.downloadURL(completion: { (url, error) in
//            if error != nil {
//              print(error!.localizedDescription)
//              return
//            }
//            if let profileImageUrl = url?.absoluteString {
//
//              let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
//              self.registeUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
//            }
//          })
//        })
//      }
//    }
//  }
  
  
  
  
  
  
  
  
  // регистрируем юзера в базу данных
//  fileprivate func registeUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
//    // ссылка на базу данных
//    let ref = Database.database().reference()
//    let userReference = ref.child("users").child(uid) // создали папку пользователя
//    userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
//      if error != nil {
//        return
//      }
//
//      let user = User(dictionary: values)
//      self.messagesController?.setupNavBarWithUser(user)
//      self.dismiss(animated: true, completion: nil)
//    })
//  }

  
  @IBAction func registrationBtnAction(_ sender: Any) {
    handleRegister()
  }
  @IBAction func closeBtnAction(_ sender: Any) {
    let controll = HelloVC.init(nibName: "HelloVC", bundle: nil)
    navigationController?.pushViewController(controll, animated: true)
    
  }
  
  @IBAction func setBtnAction(_ sender: Any) {
    handleSelectProfileImageView()
  }
  
}
