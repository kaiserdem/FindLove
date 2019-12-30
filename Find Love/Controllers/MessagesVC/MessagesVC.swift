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
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
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
  }
  

  func fetchUser() { // выбрать пользователя
    Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let user = User(dictionary: dictionary) // пользователь
        user.id = snapshot.key
        
        self.users.append(user) // добавляем в масив
        
        DispatchQueue.main.async { // на главном потоке асинхронно
          self.tableView.reloadData()
          self.setupNavBarWithUser(user)
        }
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
      let messageId = snapshot.key
      
      // сслка на сообщения по ключу 
      let messageReference = Database.database().reference().child("messages").child(messageId)
      
      // проверяем папку messages на новые сообщения
      messageReference.observeSingleEvent(of: .value, with: { (snapshot) in

        if let dictionary = snapshot.value as? [String: AnyObject] { // словарь из всего
          let message = Message(dictionary: dictionary) // помещаем в сообщение
          
          if let toId = message.toId { // если есть Id получателья
            self.messagesDictionary[toId] = message // по toId было отправлено это message сообщение
            print(self.messagesDictionary)
            self.messages = Array(self.messagesDictionary.values)
            self.messages.sort(by: { (message1, message2) -> Bool in // сортировать
              // дата первого сообщения больше чем второго
              return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
            })
          }
          DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
          })
        }

      }, withCancel: nil)

    }, withCancel: nil)
    
  }
  
  @IBAction func menyBtnAction(_ sender: Any) {
    let vc = MenuVC.init(nibName: "MenuVC", bundle: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  @IBAction func newMessageBtnAction(_ sender: Any) {
    //showChatLogVCForUser(users)
    let newMessageVC = NewMessageVC()
    newMessageVC.messagesVC = self // какой именно контролллер
    let navController = UINavigationController(rootViewController: newMessageVC)
    present(navController, animated: true, completion: nil)
  }
  
}

extension MessagesVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let user = self.users[indexPath.row]
    showChatLogVCForUser(user)
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
