//
//  SettingsVC.swift
//  Find Love
//
//  Created by Kaiserdem on 05.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit


protocol ProtocolSettingsCellDelegate: class {
  func nextButtonTapped(cell: SettingButtonNextCell)
}

class SettingsVC: UIViewController, ProtocolSettingsCellDelegate {

  @IBOutlet weak var cencelBtn: UIButton!  
  @IBOutlet weak var tableView: UITableView!
  
  var user: User?
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    
    uploadTableView()
    
    cencelBtn.setImage(UIImage(named: "cancel")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    cencelBtn.tintColor = .white
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    tableView.allowsSelection = false
    tableView.tableFooterView = UIView() // убрать все что ниже
  }
  
  
  func uploadTableView() {
    
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
  
  func nextButtonTapped(cell: SettingButtonNextCell) {
    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
    print(indexPath.row)
    
    if indexPath.row == 7 {
      print("restore purchases")
    }
    if indexPath.row == 8 {
      print("support")
      let email = "kievlandmarks@gmail.com"
      if let url = URL(string: "mailto:\(email)") {
        if #available(iOS 10.0, *) {
          UIApplication.shared.open(url)
        } else {
          UIApplication.shared.openURL(url)
        }
      }
    }
    if indexPath.row == 9 {
      print("privacy")
    }
    if indexPath.row == 10 {
      print("exit")
      postAlert("Вы действительно хотите выйти из аккаунта?")
    }
    if indexPath.row == 11 {
      print("delete account")
      
      /*
 let user = Auth.auth().currentUser
 
 user?.delete { error in
 if let error = error {
 // An error happened.
 } else {
 // Account deleted.
 }
 }
 */
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
      cell.outletSwitch.addTarget(self, action: #selector(getRandomChatsAction(_ :)), for: .touchUpInside)
      return cell
    }
    
    if indexPath.row == 2 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
      cell.outletLabel.text = "Получать сообщения от парней"
      cell.outletSwitch.addTarget(self, action: #selector(getMessageFromMenAction(_ :)), for: .touchUpInside)
      return cell
    }
    
    if indexPath.row == 3 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
      cell.outletLabel.text = "Получать сообщения от девушек"
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
    
    if indexPath.row == 5 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
      cell.outletLabel.text = "Получать уведомления"
      cell.outletSwitch.addTarget(self, action: #selector(getNotificationAction(_ :)), for: .touchUpInside)
      return cell
    }
    
    if indexPath.row == 6 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTextFieldCell", for: indexPath) as! SettingsTextFieldCell
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
    print("get Random Chats Action")
  }
  
  @objc func getMessageFromMenAction(_ sender: UISwitch) {
    print("get Message From Men Action")
  }
  
  @objc func getMessageFromWomenAction(_ sender: UISwitch) {
    print("get Message From Women Action")
  }
  
  @objc func getNotificationAction(_ sender: UISwitch) {
    print("get Notification Action")
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 && indexPath.row == 4 {
      return 40
    } else {
      return 55
    }
  }

}
