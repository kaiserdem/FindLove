//
//  MenuVC.swift
//  Find Love
//
//  Created by Kaiserdem on 24.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class ProfileVC: UIViewController {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var orientationLabel: UILabel!
  @IBOutlet weak var descriptionUserTextView: UITextView!
  @IBOutlet weak var statusTextView: UITextView!
  @IBOutlet weak var changeDataBtn: UIButton!
  @IBOutlet weak var changeStatusBtn: UIButton!
  @IBOutlet weak var changeOrientationBtn: UIButton!
  @IBOutlet weak var changeDescrintionDataBtn: UIButton!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var nameTitleLabel: UILabel!
  @IBOutlet weak var changeImageBtn: UIButton!
  @IBOutlet weak var settingsBtn: UIButton!
  
  @IBOutlet weak var heightConstraintDescriptionTextView: NSLayoutConstraint!
  @IBOutlet weak var heightConstraintStatusTextView: NSLayoutConstraint!
  var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.isHidden = true
    setupBtnSetting()
    fetchUser()
    
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide(sender:))))
  }
  
  @objc func keyboardWillHide(sender: NSNotification) {
    let infornatioView = InfornatioView(frame: self.view.frame)
    infornatioView.ageBtn.endEditing(true)
    infornatioView.genderBtn.endEditing(true)
    view.endEditing(true)
  }
  
  func fetchUser() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let user = User(dictionary: dictionary)
        user.id = snapshot.key
        self?.user = user
        self?.loadUserData(user)
        
      }
    }, withCancel: nil)
  }
   func loadUserData(_ user: User) {
    
    self.nameTitleLabel.text = user.name
    
    if user.gender != nil {
      genderLabel.textColor = .white
      genderLabel.text = String(describing: "Пол: \(genderValidatorToText(string: user.gender!))")
    } else {
      genderLabel.textColor = #colorLiteral(red: 1, green: 0.5693903705, blue: 0.4846021499, alpha: 1)
      genderLabel.text = "Введите свой пол"
    }
    
    if user.orientation != nil {
      orientationLabel.textColor = .white
      orientationLabel.text = orientationValidatorToText(string: user.orientation!)
    } else {
      orientationLabel.text = "Введите свой предпочтения"
      orientationLabel.textColor = #colorLiteral(red: 1, green: 0.5693903705, blue: 0.4846021499, alpha: 1)
    }
    
    if user.aboutSelf != nil {
      descriptionUserTextView.textColor = .white
      descriptionUserTextView.text = user.aboutSelf
//      let height = self.estimateFrameForText(user.aboutSelf!).height
//      heightConstraintDescriptionTextView.constant = height
    } else {
      descriptionUserTextView.textColor = #colorLiteral(red: 1, green: 0.5693903705, blue: 0.4846021499, alpha: 1)
      descriptionUserTextView.text = "Опишите себя, свои интересы и увлечения"
    }
    
    
    if user.age != nil {
      ageLabel.textColor = .white
      let ageString = String(describing: user.age!)
      ageLabel.text = String(describing:"Возраст: \(String(describing: user.age!))")
    } else {
      ageLabel.textColor = #colorLiteral(red: 1, green: 0.5693903705, blue: 0.4846021499, alpha: 1)
      ageLabel.text = "Введите свой возраст"
    }
    if user.status != nil {
      statusTextView.textColor = .white
      statusTextView.text = user.status
//      let height = self.estimateFrameForText(user.staus!).height
//      heightConstraintStatusTextView.constant = height
    } else {
      statusTextView.text = "Тут пока пусто, опишите свое настроение"
      statusTextView.textColor = #colorLiteral(red: 1, green: 0.5693903705, blue: 0.4846021499, alpha: 1)
    }
 
    if let profileImageView = user.profileImageUrl {
      self.profileImageView.loadImageUsingCachWithUrlString(profileImageView)
    }
  }
  
  @IBAction func changeDataBtnAction(_ sender: Any) {
    
    let view = InfornatioView(frame: self.view.frame)
    view.beforeName = (user?.name)!
    
    view.nameTextField.text = user?.name
    if user?.age !=  nil {
      view.ageBtn.setTitle(String(describing: user!.age!), for: .normal)
      view.beforeAge = String(describing: user!.age!)
    } else {
      view.ageBtn.setTitle("Тут пока пусто", for: .normal)
      view.beforeAge = String(describing:"Тут пока пусто")
    }
    if user?.gender != nil {
      view.beforeGender = genderValidatorToText(string: (user?.gender!)!)
      view.genderBtn.setTitle(genderValidatorToText(string: (user?.gender!)!), for: .normal)
    } else {
      view.genderBtn.setTitle("Выбрать из списка", for: .normal)
      view.beforeGender = "Выбрать из списка"
    }
    self.view.addSubview(view)
  }
  
  @IBAction func changeDescriptionBtnAction(_ sender: Any) {
    let view = AboutSelfView(frame: self.view.frame)
    
    
    if user?.aboutSelf != nil {
      view.aboutSelfTextView.text = user!.aboutSelf!
      view.beforeAboutSelfText = user!.aboutSelf!
      let height = estimateFrameForText(user!.status!).height + 10
      view.heightConstraintAboutSelfTextView.constant = height
    } else {
      view.aboutSelfTextView.text = "Опишите себя, свои интересы и увлечения"
      view.beforeAboutSelfText = "Опишите себя, свои интересы и увлечения"
    }
    self.view.addSubview(view)
  }
  
  @IBAction func changeStatusBtnAction(_ sender: Any) {
    let view = StatusView(frame: self.view.frame)
    
    if user?.status != nil {
      view.statusTextView.text = user!.status!
      view.beforeStatusText = user!.status!
      let height = estimateFrameForText(user!.status!).height + 10
      view.heightConstraintStatusTextView.constant = height
    } else {
      view.statusTextView.text = "Тут пока пусто, опишите свое настроение"
      view.beforeStatusText = "Тут пока пусто, опишите свое настроение"
    }
    self.view.addSubview(view)
  }
  
  @IBAction func changeOrientationBtnAction(_ sender: Any) {
    let view = OrientationView(frame: self.view.frame)
    
    if user?.orientation != nil {
      view.orientationBtn.setTitle(orientationValidatorToText(string: user!.orientation!), for: .normal)
      view.beforeOrientation = orientationValidatorToText(string: user!.orientation!)
    } else {
      view.orientationBtn.setTitle("Девушки или парни", for: .normal)
      view.beforeOrientation = "Девушки или парни"
    }
    self.view.addSubview(view)
  }
  
  @IBAction func settingsBtnAction(_ sender: Any) {
    let view = SettingsView(frame: self.view.frame)
    view.emailTextField.text = user?.email!
    self.view.addSubview(view)
  }
  
  @IBAction func changeImageBtnAction(_ sender: Any) {
    print("Set image")
    handleSelectProfileImageView()
  }
  
  private func setupBtnSetting() {
    changeDataBtn.setImage(UIImage(named: "pen")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    changeDataBtn.imageView?.tintColor = .white
    
    changeImageBtn.setImage(UIImage(named: "add")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    changeImageBtn.imageView?.tintColor = .white
    
    changeStatusBtn.setImage(UIImage(named: "pen")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    changeStatusBtn.imageView?.tintColor = .white
    
    changeOrientationBtn.setImage(UIImage(named: "pen")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    changeOrientationBtn.imageView?.tintColor = .white
    
    changeDescrintionDataBtn.setImage(UIImage(named: "pen")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    changeDescrintionDataBtn.imageView?.tintColor = .white
    
    settingsBtn.backgroundColor = .clear
    settingsBtn.layer.cornerRadius = 12
    settingsBtn.layer.borderWidth = 2
    settingsBtn.layer.borderColor = UIColor.blue.cgColor
  }  
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
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
      profileImageView.image = selectedImage
      profileImageView.setNeedsDisplay()
    }
    
    dismiss(animated: true, completion: nil) // выйти с контроллера
    
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print("canceled picker")
    dismiss(animated: true, completion: nil)
  }
}
