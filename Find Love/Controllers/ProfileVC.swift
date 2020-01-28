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
  
  @IBOutlet weak var orientationLabel: UILabel!
  @IBOutlet weak var descriptionUserTextView: UITextView!
  @IBOutlet weak var changeDataBtn: UIButton!
  @IBOutlet weak var changeStatusBtn: UIButton!
  @IBOutlet weak var changeOrientationBtn: UIButton!
  @IBOutlet weak var changeDescrintionDataBtn: UIButton!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var nameTitleLabel: UILabel!
  @IBOutlet weak var changeImageBtn: UIButton!
  @IBOutlet weak var settingsBtn: UIButton!
  
  let tableView = UITableView()
  let cellId = "Cell"
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.isHidden = true
    
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
    settingsBtn.layer.cornerRadius = 5
    settingsBtn.layer.borderWidth = 1
    settingsBtn.layer.borderColor = UIColor.blue.cgColor
  }
  
  
  @IBAction func changeDataBtnAction(_ sender: Any) {
    print("changeDataBtnAction")
  }
  @IBAction func changeDescriptionBtnAction(_ sender: Any) {
    print("changeDescriptionBtnAction")
  }
  @IBAction func changeImageBtnAction(_ sender: Any) {
    print("changeImageBtnAction")
  }
  @IBAction func changeStatusBtnAction(_ sender: Any) {
    print("changeStatusBtnAction")
  }
  @IBAction func changeOrientationBtnAction(_ sender: Any) {
    print("changeOrientationBtnAction")
  }
  @IBAction func settingsBtnAction(_ sender: Any) {
    let view = SettingsView(frame: self.view.frame)
    self.view.addSubview(view)
  }
  
}



//  func checkIfUserIsLogedIn() { // проверка если пользователь вошел в систему
//
//    if Auth.auth().currentUser?.uid == nil { // если мы не вошли
//      handleLogout()
//    } else {
//      fetchUserAndSetupNavBarTitle()
//    }
//  }
//
//  func handleLogout() { // выйти
//    do {
//      try Auth.auth().signOut()
//    } catch let logoutError {
//      print(logoutError)
//    }
//
//
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    _ = appDelegate.loadHelloVC()
//  }

