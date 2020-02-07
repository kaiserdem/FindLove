//
//  SettingsView.swift
//  Find Love
//
//  Created by Kaiserdem on 28.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class SettingsView: UIView {
  
  @IBOutlet var settingsView: UIView!
  
  @IBOutlet weak var restorePurchasesBtn: UIButton!
  @IBOutlet weak var deleteAccount: UIButton!
  @IBOutlet weak var supportBtn: UIButton!
  @IBOutlet weak var privacyBtn: UIButton!
  @IBOutlet weak var exitAccountBtn: UIButton!
 
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var getNotificationSwitch: UISwitch!
  @IBOutlet weak var getMessageFromWomanSwitch: UISwitch!
  @IBOutlet weak var getMessageFromManSwitch: UISwitch!
  @IBOutlet weak var allowRandomChatsSwitch: UISwitch!

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    
    setupBtnSettings()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  func commonInit() {
    Bundle.main.loadNibNamed("SettingsView", owner: self, options: nil)
    settingsView.fixInView(self)
  }
  
  private func setupBtnSettings() {
    restorePurchasesBtn.setImage(UIImage(named: "right")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    restorePurchasesBtn.tintColor = .white
    restorePurchasesBtn.imageView?.trailingAnchor.constraint(equalTo: restorePurchasesBtn.leadingAnchor, constant: 23.0).isActive = true
    restorePurchasesBtn.translatesAutoresizingMaskIntoConstraints = false
    restorePurchasesBtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
    
    deleteAccount.setImage(UIImage(named: "right")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    deleteAccount.tintColor = .white
    deleteAccount.imageView?.trailingAnchor.constraint(equalTo: deleteAccount.leadingAnchor, constant: 23.0).isActive = true
    deleteAccount.translatesAutoresizingMaskIntoConstraints = false
    deleteAccount.imageView?.translatesAutoresizingMaskIntoConstraints = false
    
    supportBtn.setImage(UIImage(named: "right")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    supportBtn.tintColor = .white
    supportBtn.imageView?.trailingAnchor.constraint(equalTo: supportBtn.leadingAnchor, constant: 23.0).isActive = true
    supportBtn.translatesAutoresizingMaskIntoConstraints = false
    supportBtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
    
    privacyBtn.setImage(UIImage(named: "right")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    privacyBtn.tintColor = .white
    privacyBtn.imageView?.trailingAnchor.constraint(equalTo: privacyBtn.leadingAnchor, constant: 23.0).isActive = true
    privacyBtn.translatesAutoresizingMaskIntoConstraints = false
    privacyBtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
    
    exitAccountBtn.setImage(UIImage(named: "right")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    exitAccountBtn.tintColor = .white
    exitAccountBtn.imageView?.trailingAnchor.constraint(equalTo: exitAccountBtn.leadingAnchor, constant: 23.0).isActive = true
    exitAccountBtn.translatesAutoresizingMaskIntoConstraints = false
    exitAccountBtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
  }
  @IBAction func closeBtnAction(_ sender: Any) {
    self.removeFromSuperview()
  }
  @IBAction func deleteAccountBtnAction(_ sender: Any) {
    print("deleteAccountBtnAction")
  }
  @IBAction func exitAccountBtnAction(_ sender: Any) {
    print("exitAccountBtnAction")
    handleLogout()
  }
  @IBAction func privacyBtnAction(_ sender: Any) {
    print("privacyBtnAction")
  }
  @IBAction func supportBtnAction(_ sender: Any) {
    print("supportBtnAction")
  }
  @IBAction func restorePurchasesBtnAction(_ sender: Any) {
    print("restorePurchasesBtnAction")
  }
  
  func handleLogout() { // выйти
    do {
      try Auth.auth().signOut()
    } catch let logoutError {
      print(logoutError)
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    _ = appDelegate.loadHelloVC()
  }
}
