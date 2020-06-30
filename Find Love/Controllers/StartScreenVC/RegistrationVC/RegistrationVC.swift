//
//  RegistrationVC.swift
//  Find Love
//
//  Created by Kaiserdem on 24.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//


import UIKit
import Firebase

class RegistrationVC: UIViewController, UITextFieldDelegate {
  
  // MARK: - Properties

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var setPhotoBtn: UIButton!
  @IBOutlet weak var closeBtn: UIButton!
  @IBOutlet weak var registrationBtn: UIButton!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var nameTitle: UILabel!
  @IBOutlet weak var emailTitle: UILabel!
  @IBOutlet weak var passwordTitle: UILabel!

  let buttonTFRight = UIButton(type: .custom)

  weak var menuVC: ProfileVC?
  
  var imageApproved = false
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    
    passwordTF.delegate = self
    nameTextField.delegate = self
    emailTF.delegate = self
    
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide(sender:))))
    
    passwordTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    emailTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
// MARK: - Setup Views

  func setupViews() {
    
    passwordTF.rightViewMode = .unlessEditing

    buttonTFRight.setImage(UIImage(named: "hide"), for: .normal)
    buttonTFRight.addTarget(self, action: #selector(changeStateSecure(sender:)), for: .touchUpInside)
    buttonTFRight.imageEdgeInsets = UIEdgeInsets(top: 5, left: -20, bottom: 5, right: 10)
    buttonTFRight.frame = CGRect(x: CGFloat(passwordTF.frame.size.width - 25), y: CGFloat(5), width: CGFloat(15), height: CGFloat(20))
    
    passwordTF.rightView = buttonTFRight
    passwordTF.rightViewMode = .always

    
    activityIndicator.isHidden = true
    navigationController?.navigationBar.isHidden = true
    registrationBtn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    registrationBtn.isEnabled = false
  }
  
  
  // MARK: - Helper Methods

  func faceDetection(imageToCheck: UIImage) ->Bool {
   
      let ciImage = CIImage(cgImage: imageToCheck.cgImage!)
      
      let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
      let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
      
      let faces = faceDetector.features(in: ciImage)
      
   if (faces.first as? CIFaceFeature) != nil {
          return true
      } else {
       return false
      }
  }
  
  func discardFields(emailIsDelete: Bool, passwordIsDelete: Bool, nameIsDelete: Bool,imageIsDelete: Bool) {
    activityIndicator.isHidden = true
    activityIndicator.stopAnimating()
    
    if emailIsDelete == true {
      emailTF.text = ""
    }
    if passwordIsDelete == true {
      passwordTF.text = ""
    }
    if nameIsDelete == true {
      nameTextField.text = ""
    }
    if imageIsDelete == true {
      userImageView.image = UIImage(named: "user")
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      nameTextField.resignFirstResponder()
      return true
  }
  
  private func activeButton(isActive: Bool) {
    if isActive == true {
      registrationBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      registrationBtn.isEnabled = true
    } else {
      registrationBtn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
      registrationBtn.isEnabled = false
    }
  }
  
  
  func register() {
    
    self.view.frame.origin.y = 0
    guard let email = emailTF.text , let password = passwordTF.text, let name = nameTextField.text else { return }
    
    view.endEditing(true)
    if imageApproved == false {
      self.view.frame.origin.y = 0
      let view = CustomAlertWarning(frame: self.view.frame)
      view.textTextView.text = "Добавьте свою фотографию"
      self.view.addSubview(view)
      discardFields(emailIsDelete: false, passwordIsDelete: true, nameIsDelete: false, imageIsDelete: true)
      return
    }
    
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    
    
    AuthManager.shared.handleRegister(email, password, name, userImageView.image!) { [weak self] (staus, error) in
      if error != nil {
        self?.activityIndicator.isHidden = true
        self?.activityIndicator.stopAnimating()

        let view = CustomAlertWarning(frame: (self?.view.frame)!)
        view.textTextView.text = "Что-то пошло не так, повторите попытку"
        self?.view.addSubview(view)

        self?.activityIndicator.isHidden = true
        self?.activityIndicator.stopAnimating()
        return
      }

      if staus == true {
        self?.activityIndicator.isHidden = true
        self?.activityIndicator.stopAnimating()

        AuthManager.shared.checkIfUserIsLogedIn()
      } else {
        let view = CustomAlertWarning(frame: (self?.view.frame)!)
        view.textTextView.text = "Что-то пошло не так, повторите попытку"
        self?.view.addSubview(view)
        self?.activityIndicator.isHidden = true
        self?.activityIndicator.stopAnimating()
        return
      }
    }
  }
  
  // MARK: - Actions
  
  @objc func changeStateSecure(sender: UIButton) {
    print(sender.isSelected)
    if sender.isSelected == true {
      sender.isSelected = false
      passwordTF.isSecureTextEntry.toggle()
      buttonTFRight.setImage(UIImage(named: "hide"), for: .normal)
    } else {
      sender.isSelected = true
      passwordTF.isSecureTextEntry.toggle()
      buttonTFRight.setImage(UIImage(named: "eye") , for: .normal)
    }
    reloadInputViews()
  }
  
   @objc func textFieldDidChange(sender: UITextField) {
    
    if (nameTextField.text!.count <= 3 || nameTextField.text!.count >= 20) {
      activeButton(isActive: false)
      if nameTextField.text!.count == 0 {
        nameTitle.textColor = UIColor.white
      } else {
        nameTitle.textColor = UIColor.red
      }
    } else {
      activeButton(isActive: true)
      nameTitle.textColor = UIColor.white
    }
    
    if (emailTF.text?.isEmail())! {
      activeButton(isActive: true)
      emailTitle.textColor = UIColor.white
    } else {
      activeButton(isActive: false)
      if emailTF.text!.count == 0 {
        emailTitle.textColor = UIColor.white
      } else {
        emailTitle.textColor = UIColor.red
      }
    }

    //if passwordTF.text!.count != 0 {

    if passwordTF.text!.passwordValidator(passwordTF.text!) == true {
      activeButton(isActive: true)
      passwordTitle.textColor = UIColor.white
    } else {
      activeButton(isActive: false)
      if passwordTF.text!.count == 0 {
        passwordTitle.textColor = UIColor.white
      } else {
        passwordTitle.textColor = UIColor.red
      }
    }
    
  }
  
  @objc func keyboardWillShow(sender: NSNotification) {
     self.view.frame.origin.y = -115
   }
   
   @objc func keyboardWillHide(sender: NSNotification) {
     self.view.frame.origin.y = 0
     view.endEditing(true)
   }
  
  @IBAction func registrationBtnAction(_ sender: Any) {
    register()
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    let vc = HelloVC.init(nibName: "HelloVC", bundle: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func setBtnAction(_ sender: Any) {
    handleSelectProfileImageView()
  }
}

// MARK: - Image Picker Delegate

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
    //dismiss(animated: true, completion: nil)
    
    dismiss(animated: true) {
      let imageFaceDetection = self.faceDetection(imageToCheck: self.userImageView.image!)
      
      if imageFaceDetection == false {
        let view = CustomAlertWarning(frame: self.view.frame)
        view.textTextView.text = "На фографии не было обнаружено пользователя, пожалуйста выбери фографию со своим лицом"
        view.textViewConstraintHeight.constant = 100
        self.view.addSubview(view)
        self.imageApproved = false
      } else {
        self.imageApproved = true

      }
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}


extension String {
  
  func isValidEmail() -> Bool {
    // here, `try!` will always succeed because the pattern is valid
    let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
    return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
  }
  
  func isEmail()->Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
  }
  
  func passwordValidator(_ password: String) -> Bool {
    
    if(password.count > 7 && password.count < 17) {
      } else {
          return false
      }
      let nonUpperCase = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
      let letters = password.components(separatedBy: nonUpperCase)
      let strUpper: String = letters.joined()

      let smallLetterRegEx  = ".*[a-z]+.*"
      let samlltest = NSPredicate(format:"SELF MATCHES %@", smallLetterRegEx)
      let smallresult = samlltest.evaluate(with: password)

      let numberRegEx  = ".*[0-9]+.*"
      let numbertest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
      let numberresult = numbertest.evaluate(with: password)

      let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
      var isSpecial :Bool = false
      if regex.firstMatch(in: password, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, password.count)) != nil {
       print("could not handle special characters")
          isSpecial = true
      }else{
          isSpecial = false
      }
      return (strUpper.count >= 1) && smallresult && numberresult && isSpecial
  }
  
  
  
  var isValidPassword: Bool {
      do {
          let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
          if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil){

              if(self.count>=6 && self.count<=20){
                  return true
              }else{
                  return false
              }
          }else{
              return false
          }
      } catch {
          return false
      }
  }
  
}
