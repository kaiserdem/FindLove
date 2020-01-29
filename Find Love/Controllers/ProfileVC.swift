//
//  MenuVC.swift
//  Find Love
//
//  Created by Kaiserdem on 24.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


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
  
  var user: User?
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.isHidden = true
    setupBtnSetting()
    fetchUser()
  }
  
  func fetchUser() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        print(dictionary)
        let user = User(dictionary: dictionary)
        user.id = snapshot.key
        self?.loadUserData(user)
        
      }
    }, withCancel: nil)
  }
   func loadUserData(_ user: User) {
    
    self.nameTitleLabel.text = user.name
    
    if user.gender != nil {
      self.genderLabel.text = genderValidator(string: user.gender!)
    } else {
      self.genderLabel.text = "Введите свой пол"
    }
    
    if user.orientation != nil {
      self.orientationLabel.text = orientationValidator(string: user.orientation!)
    } else {
      self.orientationLabel.text = "Введите свой предпочтения"
    }
    
    
    let aboutSelf = user.aboutSelf ?? "Опишите себя, свои интересы и увлечения"
    self.descriptionUserTextView.text = aboutSelf
    if user.age != nil {
      self.ageLabel.text = String(describing:"Возраст: \(String(describing: user.age!))")
    } else {
      self.ageLabel.text = "Введите свой возраст"
    }
    let status = user.staus ?? "Тут пока пусто, опишите свое настроение"
    self.statusTextView.text = status
 
    if let profileImageView = user.profileImageUrl {
      self.profileImageView.loadImageUsingCachWithUrlString(profileImageView)
    }
  }
  func genderValidator(string: String) -> String {
    if string == "1" {
      return "Мужчина"
    } else {
      return "Женщина"
    }
  }
  
  func orientationValidator(string: String) -> String {
    if string == "1" {
      return "Девушки"
    } else if string == "2" {
      return "Парни"
    } else {
      return "Девушки и парни"
    }
  }
  
  
  
  @IBAction func changeDataBtnAction(_ sender: Any) {
    let view = InfornatioView(frame: self.view.frame)
    self.view.addSubview(view)
  }
  @IBAction func changeDescriptionBtnAction(_ sender: Any) {
    let view = AboutSelfView(frame: self.view.frame)
    self.view.addSubview(view)
  }
  @IBAction func changeImageBtnAction(_ sender: Any) {
    print("changeImageBtnAction")
  }
  @IBAction func changeStatusBtnAction(_ sender: Any) {
    let view = StatusView(frame: self.view.frame)
    self.view.addSubview(view)
  }
  @IBAction func changeOrientationBtnAction(_ sender: Any) {
    let view = OrientationView(frame: self.view.frame)
    self.view.addSubview(view)
  }
  @IBAction func settingsBtnAction(_ sender: Any) {
    let view = SettingsView(frame: self.view.frame)
    self.view.addSubview(view)
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
