//
//  MessagesTableVC.swift
//  Find Love
//
//  Created by Kaiserdem on 26.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UIViewController {
  
  @IBOutlet weak var topBarView: UIView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var menyBtn: UIButton!
  @IBOutlet weak var newMessageBtn: UIButton!
  @IBOutlet weak var backViewTable: UIView!
  
  
  let tableView = UITableView()
  let cellId = "Cell"
  var users = [User]()
  var messages = [Message]()
  var messagesDictionary = [String: Message]()
  var menuVC: MenuVC?
  var timer: Timer?
  
//  override var prefersStatusBarHidden: Bool {
//    return true
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchUser()
    uploadTableView()
    observeUserMessages()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    topBarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 25.0)
  }
  
  func uploadTableView() {
    
    tableView.delegate = self
    tableView.dataSource = self
    
    backViewTable.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: backViewTable.topAnchor).isActive = true
    tableView.leftAnchor.constraint(equalTo: backViewTable.leftAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: backViewTable.bottomAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: backViewTable.rightAnchor).isActive = true
    
    tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    tableView.allowsMultipleSelectionDuringEditing = true
  }
  

  func fetchUser() { // выбрать пользователя

    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        let user = User(dictionary: dictionary)
        self.setupNavBarWithUser(user)
      }
    }, withCancel: nil)
  }
  
  func setupNavBarWithUser(_ user: User) {
    messages.removeAll()
    messagesDictionary.removeAll()
    tableView.reloadData()
    userNameLabel.text = user.name
    
    observeUserMessages()
  }
  
  func showChatLogVCForUser(_ user: User?) {
    let vc = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
    vc.user = user
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func observeUserMessages() {
    // айди текущий пользователь
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    // ссылка на все сообщения пользователя
    let ref = Database.database().reference().child("user-messages").child(uid)
    ref.observe(.childAdded, with: { (snapshot) in
      
      // ключ сообщения
      let userId = snapshot.key
      Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
        
        let messageId = snapshot.key
        self.fetchMessageWithaMessageId(messageId)
        
      }, withCancel: nil)
    }, withCancel: nil)
    
    ref.observe(.childMoved) { (snapchot) in // наблюдать за удвлением
      self.attempReloadOfTable()
    }
  }
  
  private func fetchMessageWithaMessageId(_ messageId: String) {
    // сслка на сообщения по ключу
    let messageReference = Database.database().reference().child("messages").child(messageId)
    
    // проверяем папку messages на новые сообщения
    messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] { // словарь из всего
        let message = Message(dictionary: dictionary) // помещаем в сообщение
        
        if let chatPartnerId = message.chatPartnerId() { // если есть Id получателья
          self.messagesDictionary[chatPartnerId] = message // по toId было отправлено это message сообщение
        }
        self.attempReloadOfTable()
      }
    }, withCancel: nil)
  }
  
  private func attempReloadOfTable() { // вызывает таймер
    timer?.invalidate()
    timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.tableReloadTable), userInfo: nil, repeats: true)
  }
  
  @objc func tableReloadTable() {
    self.messages = Array(self.messagesDictionary.values)
    self.messages.sort(by: { (message1, message2) -> Bool in //сортировать по времени
      // дата первого сообщения больше чем второго
      return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
    })
    DispatchQueue.main.async(execute: {
      self.tableView.reloadData()
    })
  }
  
  @IBAction func menyBtnAction(_ sender: Any) {
    let vc = MenuVC.init(nibName: "MenuVC", bundle: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  @IBAction func newMessageBtnAction(_ sender: Any) {
    let newMessageVC = NewMessageVC()
    newMessageVC.messagesVC = self // какой именно контролллер
    let navController = UINavigationController(rootViewController: newMessageVC)
    present(navController, animated: true, completion: nil)
  }
  
}

extension MessagesVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let message = messages[indexPath.row]
    
    if let chatPartnerId = message.chatPartnerId() {
      Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue { (error, ref) in
        if error != nil {
          print("Failed to delete messages:", error!)
          return
        }
        self.messagesDictionary.removeValue(forKey: chatPartnerId)
        self.attempReloadOfTable()
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let message = self.messages[indexPath.row] //
    guard let chatPartnerId = message.chatPartnerId() else { return }
    
    // берем
    let ref = Database.database().reference().child("users").child(chatPartnerId)
    ref.observe(.value, with: { (snapshot) in
      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
      
      let user = User(dictionary: dictionary)
      user.id = chatPartnerId
      self.showChatLogVCForUser(user)
    }, withCancel: nil)
  }
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  messages.count
  }
  
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
    
    let message = messages[indexPath.row]
    cell.message = message
    
    return cell
  }
  
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65
  }
}
