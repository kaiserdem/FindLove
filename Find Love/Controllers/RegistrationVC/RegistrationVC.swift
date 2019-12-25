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
      })
    }
  }

  @IBAction func registrationBtnAction(_ sender: Any) {
    handleRegister()
  }
  @IBAction func closeBtnAction(_ sender: Any) {
    let controll = HelloVC.init(nibName: "HelloVC", bundle: nil)
    navigationController?.pushViewController(controll, animated: true)
    
  }
}
