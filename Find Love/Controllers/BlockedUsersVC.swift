//
//  BlockedUsersVC.swift
//  Find Love
//
//  Created by Kaiserdem on 13.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit


class BlockedUsersVC: UIViewController {
  
  @IBOutlet weak var cencelBtn: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  let defaults = UserDefaults.standard
  lazy var arrayBlockUsers = defaults.stringArray(forKey: "arrayBlockUsers") ?? [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

      uploadTableView()

    }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    tableView.allowsSelection = false
    tableView.tableFooterView = UIView() // убрать все что ниже
  }
  private func uploadTableView() {
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.showsVerticalScrollIndicator = false
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    

    
    tableView.register(UINib(nibName: "SettingButtonNextCell", bundle: nil), forCellReuseIdentifier: "SettingButtonNextCell")

  
}

  extension BlockedUsersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 
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
        cell.nextButtonOutlet.setTitle("Черный список", for: .normal)
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
