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
import FirebaseStorage

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
  
  weak var menuVC: MenuVC?
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

      
        navigationController?.navigationBar.isHidden = true
      
      self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide(sender:))))
    }
  
  @objc func keyboardWillHide(sender: NSNotification) {
    view.endEditing(true)
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
      let imageName = NSUUID().uuidString // генерирует случайный айди
      // создали папку  для картинке в базе
      let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
      
      if let profileImage = self.userImageView.image, let  uploadData = profileImage.jpegData(compressionQuality: 0.1) {
        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
          
          if error != nil {
            print(error ?? "")
            return
          }
          // могут быть ошибки
          storageRef.downloadURL(completion: { (url, error) in
            if error != nil {
              print(error!.localizedDescription)
              return
            }
            if let profileImageUrl = url?.absoluteString {
              
              let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
              self.registeUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
            }
          })
        })
      }
    }
  }
  
  fileprivate func registeUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
    
    let ref = Database.database().reference()
    let userReference = ref.child("users").child(uid) // создали папку пользователя
    userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
      if error != nil {
        return
      }
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      _ = appDelegate.checkIfUserIsLogedIn()
    })
  }
  
  @IBAction func registrationBtnAction(_ sender: Any) {
    handleRegister()
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    let vc = HelloVC.init(nibName: "HelloVC", bundle: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func setBtnAction(_ sender: Any) {
    handleSelectProfileImageView()
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
