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
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var setPhotoBtn: UIButton!
  @IBOutlet weak var closeBtn: UIButton!
  @IBOutlet weak var registrationBtn: UIButton!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  
  weak var menuVC: ProfileVC?
  var imageStatus = 0
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.isHidden = true
    navigationController?.navigationBar.isHidden = true
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide(sender:))))
  }
  
  @objc func keyboardWillShow(sender: NSNotification) {
    self.view.frame.origin.y = -115
  }
  
  @objc func keyboardWillHide(sender: NSNotification) {
    self.view.frame.origin.y = 0
    view.endEditing(true)
  }
  
  
  func handleRegister() {
    guard let email = emailTF.text , let password = passwordTF.text, let name = nameTextField.text else { // если пустые, принт, выходим
      print("Error: field is empty")
      
      activityIndicator.isHidden = true
      activityIndicator.stopAnimating()
      return
    }
    
    if imageStatus == 0 {
      let view = CustomAlertWarning(frame: self.view.frame)
      view.textTextView.text = "Без фотографии регистрация невозможна"
      self.view.addSubview(view)
      activityIndicator.isHidden = true
      activityIndicator.stopAnimating()
      return
    }
    
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
      if error != nil { // если ошибка, принт, выходим
        print("Error")
        self?.activityIndicator.isHidden = true
        self?.activityIndicator.stopAnimating()
        return
      }
      // успешно
      
      guard let uid = user?.user.uid else { // создаем айди пользователя
        return
      }
      let imageName = NSUUID().uuidString // генерирует случайный айди
      // создали папку  для картинке в базе
      let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
      
      if let profileImage = self?.userImageView.image, let  uploadData = profileImage.jpegData(compressionQuality: 0.1) {
        storageRef.putData(uploadData, metadata: nil, completion: { [weak self] (metadata, error) in
          
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
              self?.registeUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
            }
          })
        })
      }
      
    }
  }
  
  fileprivate func registeUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
    
    let ref = Database.database().reference()
    let userReference = ref.child("users").child(uid) // создали папку пользователя
    userReference.updateChildValues(values, withCompletionBlock: { [weak self] (error, ref) in
      if error != nil {
        return
      }
      self?.activityIndicator.isHidden = true
      self?.activityIndicator.stopAnimating()
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      _ = appDelegate.checkIfUserIsLogedIn()
    })
  }
  
  @IBAction func registrationBtnAction(_ sender: Any) {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
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
      imageStatus = 1
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
