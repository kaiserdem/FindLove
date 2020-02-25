//
//  MessagesAllVC.swift
//  Find Love
//
//  Created by Kaiserdem on 11.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class MessagesVC: UIViewController {
  
  let tableView = UITableView()
  var messages = [Message]()
  var messagesDictionary = [String: Message]() // для сортировки
  var timer: Timer?
  var user: User?
  
  let defaults = UserDefaults.standard
  lazy var arrayBlockUsers = defaults.stringArray(forKey: "arrayBlockUsers") ?? [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchUser()
    uploadTableView()
   // observeUser()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    loadUserMessages()
    observeChatInvitation()
  }
  
//  private func observeUser() {
//
//    guard let uid = Auth.auth().currentUser?.uid else { return }
//
//    let ref = Database.database().reference().child("users").child(uid)
//    ref.observe(.childAdded, with: { [weak self] (snapshot) in
//
//      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
//      let user = User(dictionary: dictionary)
//      self?.user = user
//
//      }, withCancel: nil)
//  }
  
  private func observeChatInvitation() {
    
    arrayBlockUsers = defaults.stringArray(forKey: "arrayBlockUsers") ?? [String]()
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let ref = Database.database().reference().child("user-request").child(uid)
    ref.observe(.childAdded, with: { [weak self] (snapshot) in
      
      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
      
      let request = Request(dictionary: dictionary)
      
      if request.toId == uid {
        if self?.arrayBlockUsers.contains(request.fromUserId!) == false {
          if request.statusRequest == "0" {
            let invitationView = ChatInvitationView(frame: (self?.view.frame)!)
            invitationView.request = request
            invitationView.toGroupTextView.text = request.toGroup
            invitationView.userNameLabel.text = request.fromUser
            invitationView.userImageView.loadImageUsingCache(request.fromImageUrl!)
            invitationView.requestId = snapshot.key
            self?.view.addSubview(invitationView)
          }
        } else {
          ref.child(snapshot.key).removeValue()
        }
      }
      }, withCancel: nil)
  }
  
  private func uploadTableView() {
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.backgroundColor = .black
    
    self.view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    
    tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    tableView.register(UINib(nibName: "ChatWithStrangerCell", bundle: nil), forCellReuseIdentifier:"ChatWithStrangerCell")
    tableView.allowsMultipleSelectionDuringEditing = true
  }
  
  private func fetchUser() { // выбрать пользователя
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let user = User(dictionary: dictionary)
        user.id = snapshot.key
        self?.loadUserMessages()
      }
    }, withCancel: nil)
  }
  
  private func loadUserMessages() {
    messages.removeAll()
    messagesDictionary.removeAll()
    observeUserMessages()
    tableView.reloadData()
  }
  
  private func openSearchStrangerView() {
    let view =  SearchStrangerForChatView(frame: self.view.frame)
    self.view.addSubview(view)
  }
  
  private func showChatLogVCForUser(_ user: User?) {
    let vc = ChatMessageCVC(collectionViewLayout: UICollectionViewFlowLayout())
    vc.user = user
    present(vc, animated: true, completion: nil)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  private func observeUserMessages() {
    
    arrayBlockUsers = defaults.stringArray(forKey: "arrayBlockUsers") ?? [String]()
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
   
    // ссылка на все сообщения пользователя
    let ref = Database.database().reference().child("user-messages").child(uid)
    ref.observe(.childAdded, with: { [weak self] (snapshot) in
      if self?.arrayBlockUsers.contains(snapshot.key) == false {
        // ключ сообщения
        let userId = snapshot.key
        
        Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
          let messageId = snapshot.key
          
          //
          self?.fetchMessageWithaMessageId(messageId)
        }, withCancel: nil)
      }
    }, withCancel: nil)
    ref.observe(.childMoved) { [weak self] (snapchot) in // наблюдать за удвлением
      self?.attempReloadOfTable(true)
    }
  }
  
  private func fetchMessageWithaMessageId(_ messageId: String) {
    
    // сслка на сообщения по ключу
    let messageReference = Database.database().reference().child("messages").child(messageId)
    
    // проверяем папку messages на новые сообщения
    messageReference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] { // словарь из всего
        let message = Message(dictionary: dictionary) // помещаем в сообщение
        
        if let chatPartnerId = message.chatPartnerId() { // если есть Id получателья
          self?.messagesDictionary[chatPartnerId] = message // по toId было отправлено это message сообщение
        }
        self?.attempReloadOfTable(true)
      }
    }, withCancel: nil)
  }
  
  private func attempReloadOfTable(_ allow: Bool) { // вызывает таймер
    timer?.invalidate()
    if allow == true {
      timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.tableReloadTable), userInfo: nil, repeats: true)
    }
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
}

extension MessagesVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    self.attempReloadOfTable(false)

    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let message = messages[indexPath.row]
    
    if let chatPartnerId = message.chatPartnerId() {
      Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue { [weak self] (error, ref) in
        if error != nil {
          print("Failed to delete messages:", error!)
          return
        }
        self?.messagesDictionary.removeValue(forKey: chatPartnerId)
        self?.attempReloadOfTable(true)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      openSearchStrangerView()
      return
    }
    let message = self.messages[indexPath.row - 1]
    guard let chatPartnerId = message.chatPartnerId() else { return }
    
    let ref = Database.database().reference().child("users").child(chatPartnerId)
    ref.observe(.value, with: { [weak self] (snapshot) in
      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
      
      let user = User(dictionary: dictionary)
      user.id = chatPartnerId
      self?.showChatLogVCForUser(user)
    }, withCancel: nil)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  messages.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ChatWithStrangerCell", for: indexPath) as! ChatWithStrangerCell
      return cell
    } else {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
    let message = messages[indexPath.row - 1]
    cell.message = message
    return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65
  }
}
