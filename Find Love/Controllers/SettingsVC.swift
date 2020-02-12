//
//  SettingsVC.swift
//  Find Love
//
//  Created by Kaiserdem on 05.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseDatabase

protocol ProtocolSettingsCellDelegate: class {
  func nextButtonTapped(cell: SettingButtonNextCell)
  func saveTextFieldTapped(cell: SettingsTextFieldCell, string: String)
}

class SettingsVC: UIViewController, ProtocolSettingsCellDelegate {
  
  @IBOutlet weak var cencelBtn: UIButton!  
  @IBOutlet weak var tableView: UITableView!
  
  var user: User?
  var posts = [Post]()
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    let objUser = UserDefaults.standard.retrieve(object: User.self, fromKey: "currentUserKey")
    user = objUser
    
    uploadTableView()
    
    cencelBtn.setImage(UIImage(named: "cancel")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    cencelBtn.tintColor = .white
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide(sender:))))
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    tableView.allowsSelection = false
    tableView.tableFooterView = UIView() // убрать все что ниже
  }
  
  @objc func keyboardWillShow(sender: NSNotification) {
    self.view.frame.origin.y = -110
  }
  
  @objc func keyboardWillHide(sender: NSNotification) {
    self.view.frame.origin.y = 0
    view.endEditing(true)
  }
  
  private func saveValueToDatabase(_ name: String, _ value: String) {
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let ref = Database.database().reference().child("users").child(uid)
    
    let valuesStatus = [name: value] as [String : Any]
    ref.updateChildValues(valuesStatus)
  }
 
  private func sendMessameToSupport() {
    let email = "kievlandmarks@gmail.com"
    if let url = URL(string: "mailto:\(email)") {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }
  
  private func handleLogout() {
    do {
      try Auth.auth().signOut()
    } catch let logoutError {
      print(logoutError)
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    _ = appDelegate.loadHelloVC()
  }
  
  private func deleteAccountFromFirebase() {
    let user = Auth.auth().currentUser
    if user == nil {
      self.handleLogout()
      return
    }
    let uid = Auth.auth().currentUser?.uid
    user?.delete { [weak self] error in
      if let error = error {
        print("An error happened.")
        print(error.localizedDescription as Any)
        self?.showAlert(title: "Произошла ошибка, попробовать снова", success: {
          self?.deleteAccountFromFirebase()
        }, cancel: {
          return
        })
      } else {
        print("Account deleted.")
        self?.deleteUsersDataAndHistory(uid!)
        self?.handleLogout()
      }
    }
  }
  private func deleteUsersDataAndHistory(_ uid: String) {
    let refUser = Database.database().reference().child("users").child(uid)
    let refUserMessages = Database.database().reference().child("user-messages").child(uid)
    let refPosts = Database.database().reference().child("posts")
    
    let ref = Storage.storage().reference().child("profile_images")
    let refImage = ref.storage.reference(forURL: (user?.profileImageUrl)!)
    
    refImage.delete { error in // фото не удаляеться
      if let error = error {
        print(error.localizedDescription as Any)
      } else {
        print("File deleted successfully")
      }
    }
    refPosts.observe(.value) { (snapshot) in // delete user feed post
      for child in snapshot.children {
        let snap = child as! DataSnapshot
        if let dictionary = snap.value as? [String: AnyObject] {
          let post = Post(dictionary: dictionary)
          if post.fromId == uid {
            let refSnap = child as! DataSnapshot
            refSnap.ref.removeValue()
          }
        }
      }
    }
    refUserMessages.removeValue()
    refUser.removeValue()
  }
  
  private func uploadTableView() {
    
    tableView.delegate = self
    tableView.dataSource = self

    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.showsVerticalScrollIndicator = false
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    
    tableView.register(UINib(nibName: "SettingsHeaderCell", bundle: nil), forCellReuseIdentifier: "SettingsHeaderCell")
    
    tableView.register(UINib(nibName: "SettingsSwitchCell", bundle: nil), forCellReuseIdentifier: "SettingsSwitchCell")
    
    tableView.register(UINib(nibName: "SettingsTextFieldCell", bundle: nil), forCellReuseIdentifier: "SettingsTextFieldCell")
    
    tableView.register(UINib(nibName: "SettingButtonNextCell", bundle: nil), forCellReuseIdentifier: "SettingButtonNextCell")
  }
  
  func saveTextFieldTapped(cell: SettingsTextFieldCell, string: String) {
    self.view.frame.origin.y = 0
    
    guard let currentUser = Auth.auth().currentUser else { return }
    
    let refUsers = Database.database().reference().child("users").child(currentUser.uid)
    
    currentUser.updateEmail(to: string) { error in
      if let error = error {
        print(error)
        let view = CustomAlertWarning(frame: self.view.frame)
        view.label.text = "Ошибка"
        view.textTextView.text = "Выполните повторный вход в свой аккаунт и повторите действие"
        self.view.addSubview(view)
        return
      } else {
        let thisUserEmailRef = refUsers.child("email")
        thisUserEmailRef.setValue(string)
        let view = CustomAlertWarning(frame: self.view.frame)
        view.label.text = "Успешно"
        view.textTextView.text = "Электронная почта авторизации была изменена"
        self.view.addSubview(view)
      }
    }
    view.endEditing(true)
  }

  func nextButtonTapped(cell: SettingButtonNextCell) {
    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
    
    if indexPath.row == 7 {
      print("restore purchases")
    }
    if indexPath.row == 8 {
      sendMessameToSupport()
    }
    if indexPath.row == 9 {
      let view = SettingPrivacyView(frame: self.view.frame)
      self.view.addSubview(view)
    }
    if indexPath.row == 10 {
      showAlert(title: "Вы действительно хотите выйти из аккаунта?",success: { [weak self] () -> Void in
        self?.handleLogout()
      }) { () -> Void in
        print("cancel")
      }
    }
    if indexPath.row == 11 {
      print("delete account")
      showAlert(title: "Вы действительно хотите удалить аккаунт со всеми его данными?",success: { [weak self] () -> Void in
        self?.deleteAccountFromFirebase()
      }) { () -> Void in
        print("cancel")
      }
    }
  }

  @IBAction func cencelBtnAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 12
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsHeaderCell", for: indexPath) as! SettingsHeaderCell
      cell.titleLabel.text = "Чат"
      cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
      return cell
    }
    
    if indexPath.row == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
      cell.outletLabel.text = "Разрешить случайные чаты"
      if user?.getRandomChat != nil {
        if user?.getRandomChat! == "0" {
          cell.outletSwitch.isOn = false
        } else {
          cell.outletSwitch.isOn = true
        }
      }
      cell.outletSwitch.addTarget(self, action: #selector(getRandomChatsAction(_ :)), for: .touchUpInside)
      return cell
    }
    
    if indexPath.row == 2 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
      cell.outletLabel.text = "Получать сообщения от парней"
      if user?.getMessageFromMen != nil {
        if user?.getRandomChat! == "0" {
          cell.outletSwitch.isOn = false
        } else {
          cell.outletSwitch.isOn = true
        }
      }
      cell.outletSwitch.addTarget(self, action: #selector(getMessageFromMenAction(_ :)), for: .touchUpInside)
      return cell
    }
    
    if indexPath.row == 3 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
      cell.outletLabel.text = "Получать сообщения от девушек"
      if user?.getMessageFromWomen != nil {
        if user?.getMessageFromWomen! == "0" {
          cell.outletSwitch.isOn = false
        } else {
          cell.outletSwitch.isOn = true
        }
      }
      cell.outletSwitch.addTarget(self, action: #selector(getMessageFromWomenAction(_ :)), for: .touchUpInside)
      cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
      return cell
    }
    
    if indexPath.row == 4 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsHeaderCell", for: indexPath) as! SettingsHeaderCell
      cell.titleLabel.text = "Основное"
      cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
      return cell
    }
    // функционал не создан
    if indexPath.row == 5 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
      cell.outletLabel.text = "Получать уведомления"
      cell.outletSwitch.addTarget(self, action: #selector(getNotificationAction(_ :)), for: .touchUpInside)
      return cell
    }
    
    if indexPath.row == 6 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTextFieldCell", for: indexPath) as! SettingsTextFieldCell
      cell.outletTextField.text = user?.email! ?? "someEmail@gmail.com"
      cell.delegate = self
      return cell
    }
    
    if indexPath.row == 7 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingButtonNextCell", for: indexPath) as! SettingButtonNextCell
      cell.delegate = self
      cell.nextButtonOutlet.setTitle("Восстановить покупки", for: .normal)
      return cell
    }
    
    if indexPath.row == 8 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingButtonNextCell", for: indexPath) as! SettingButtonNextCell
      cell.delegate = self
      cell.nextButtonOutlet.setTitle("Служба поддержки", for: .normal)
      return cell
    }
    
    if indexPath.row == 9 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingButtonNextCell", for: indexPath) as! SettingButtonNextCell
      cell.delegate = self
      cell.nextButtonOutlet.setTitle("Политика конфиденциальности", for: .normal)
      return cell
    }
    
    if indexPath.row == 10 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingButtonNextCell", for: indexPath) as! SettingButtonNextCell
      cell.delegate = self
      cell.nextButtonOutlet.setTitle("Выйти из аккаунта", for: .normal)
      return cell
    }
    
    if indexPath.row == 11 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingButtonNextCell", for: indexPath) as! SettingButtonNextCell
      cell.delegate = self
      cell.nextButtonOutlet.setTitle("Удалить аккаунт", for: .normal)
      return cell
    }
    return UITableViewCell()
  }
  
  @objc func getRandomChatsAction(_ sender: UISwitch) {
    if sender.isOn == true {
      print("on")
      saveValueToDatabase("getRandomChat", "1")
    } else {
      print("off")
      saveValueToDatabase("getRandomChat", "0")
    }
  }
  
  @objc func getMessageFromMenAction(_ sender: UISwitch) {
    if sender.isOn == true {
      print("on")
      saveValueToDatabase("getMessageFromMen", "1")
    } else {
      print("off")
      saveValueToDatabase("getMessageFromMen", "0")
    }
  }
  
  @objc func getMessageFromWomenAction(_ sender: UISwitch) {
    if sender.isOn == true {
      print("on")
      saveValueToDatabase("getMessageFromWomen", "1")
    } else {
      print("off")
      saveValueToDatabase("getMessageFromWomen", "0")
    }
  }
  
  // функционал не создан
  @objc func getNotificationAction(_ sender: UISwitch) {
    if sender.isOn == true {
      print("on")
      //setValueToDatabase("getMessageFromWomen", "1")
    } else {
      print("off")
      //setValueToDatabase("getMessageFromWomen", "0")
    }
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 && indexPath.row == 4 {
      return 40
    } else {
      return 55
    }
  }

}
