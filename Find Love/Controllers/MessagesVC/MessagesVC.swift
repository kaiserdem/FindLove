//
//  MessagesTableVC.swift
//  Find Love
//
//  Created by Kaiserdem on 26.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MessagesVC: UIViewController {
  
  @IBOutlet weak var messageBarBtnView: UIView!
  @IBOutlet weak var chatBarBtnView: UIView!
  @IBOutlet weak var newMessageBarBtnView: UIView!
  @IBOutlet weak var topBarView: UIView!
  @IBOutlet weak var backViewTable: UIView!
  
  
  let tableView = UITableView()
  let cellId = "Cell"
  var users = [User]()
  var messages = [Message]()
  var messagesDictionary = [String: Message]()
  var menuVC: MenuVC?
  var timer: Timer?
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchUser()
    uploadTableView()
    observeUserMessages()
    setupTopBarSettings()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    messageBarBtnView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    chatBarBtnView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    newMessageBarBtnView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    
  }
  
  func uploadTableView() {
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.backgroundColor = .black
    
    backViewTable.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: backViewTable.topAnchor).isActive = true
    tableView.leftAnchor.constraint(equalTo: backViewTable.leftAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: backViewTable.bottomAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: backViewTable.rightAnchor).isActive = true
    
    tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    tableView.allowsMultipleSelectionDuringEditing = true
  }
  
  private func setupTopBarSettings() {
 
    let messageGestures = UITapGestureRecognizer(target: self, action:  #selector (messageBtnAction (_:)))
    let chatBtnGestures = UITapGestureRecognizer(target: self, action:  #selector (chatBtnAction (_:)))
    let writeBtnGestures = UITapGestureRecognizer(target: self, action:  #selector (writeBtnAction (_:)))
    
    self.messageBarBtnView.addGestureRecognizer(messageGestures)
    self.chatBarBtnView.addGestureRecognizer(chatBtnGestures)
    self.newMessageBarBtnView.addGestureRecognizer(writeBtnGestures)
  
  }
  
  @objc func messageBtnAction(_ sender:UITapGestureRecognizer){
    
    print("messageBtnAction")
    
      self.messageBarBtnView.backgroundColor = .white
      self.messageBarBtnView.layer.shadowOffset = CGSize(width: 0.5, height: -1.0)
      self.messageBarBtnView.layer.shadowRadius = 1.5
      self.messageBarBtnView.layer.shadowOpacity = 0.2

      self.chatBarBtnView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      self.chatBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
      self.chatBarBtnView.layer.shadowRadius = 0
      self.chatBarBtnView.layer.shadowOpacity = 0
      
      self.newMessageBarBtnView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      self.newMessageBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
      self.newMessageBarBtnView.layer.shadowRadius = 0
      self.newMessageBarBtnView.layer.shadowOpacity = 0
    
  }
  
  @objc func chatBtnAction(_ sender:UITapGestureRecognizer){
    
    print("chatBtnAction")
    
    self.chatBarBtnView.backgroundColor = .white
    self.chatBarBtnView.layer.shadowOffset = CGSize(width: 0.5, height: -1.0)
    self.chatBarBtnView.layer.shadowRadius = 1.5
    self.chatBarBtnView.layer.shadowOpacity = 0.2
    
    self.newMessageBarBtnView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    self.newMessageBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.newMessageBarBtnView.layer.shadowRadius = 0
    self.newMessageBarBtnView.layer.shadowOpacity = 0
    
    self.messageBarBtnView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    self.messageBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.messageBarBtnView.layer.shadowRadius = 0
    self.messageBarBtnView.layer.shadowOpacity = 0
    
  }
  
  @objc func writeBtnAction(_ sender:UITapGestureRecognizer){
    
    print("writeBtnAction")
    
    self.newMessageBarBtnView.backgroundColor = .white
    self.newMessageBarBtnView.layer.shadowOffset = CGSize(width: 0.5, height: -1.0)
    self.newMessageBarBtnView.layer.shadowRadius = 1.5
    self.newMessageBarBtnView.layer.shadowOpacity = 0.2
    
    self.messageBarBtnView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    self.messageBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.messageBarBtnView.layer.shadowRadius = 0
    self.messageBarBtnView.layer.shadowOpacity = 0
    
    self.chatBarBtnView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    self.chatBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.chatBarBtnView.layer.shadowRadius = 0
    self.chatBarBtnView.layer.shadowOpacity = 0
    
    
    
    let newMessageVC = NewMessageVC()
    newMessageVC.messagesVC = self // какой именно контролллер
    let navController = UINavigationController(rootViewController: newMessageVC)
    present(navController, animated: true, completion: nil)
    
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
    //userNameLabel.text = user.name
    
    observeUserMessages()
  }
  
  func showChatLogVCForUser(_ user: User?) {
    let vc = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
    vc.user = user
    present(vc, animated: true, completion: nil)
    //self.navigationController?.pushViewController(vc, animated: true)
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
      self.attempReloadOfTable(true)
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
        self.attempReloadOfTable(true)
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
  
    self.attempReloadOfTable(false)
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let message = messages[indexPath.row]
    
    if let chatPartnerId = message.chatPartnerId() {
      Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue { (error, ref) in
        if error != nil {
          print("Failed to delete messages:", error!)
          return
        }
        self.messagesDictionary.removeValue(forKey: chatPartnerId)
        self.attempReloadOfTable(true)
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
