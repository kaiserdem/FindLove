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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchUser()
    uploadTableView()
    observeMessages()
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
        
        self.setupNavBarWithUser(user)
        
        DispatchQueue.main.async { // на главном потоке асинхронно
          self.tableView.reloadData()
        }
      }
    }, withCancel: nil)
  }
  
  func setupNavBarWithUser(_ user: User) {
    userNameLabel.text = user.name
  }
  
  func showChatLogVCForUser(_ user: User?) {
    let vc = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
    vc.user = user
    navigationController?.pushViewController(vc, animated: true)
  }
  
    func observeMessages() {
      
      let ref = Database.database().reference().child("messages")
      ref.observe(.childAdded, with: { (snapshot) in
        
        if let dictionary = snapshot.value as? [String: AnyObject] {
          let message = Message(dictionary: dictionary)
          
          if let toId = message.toId { // по этому id отправлено это сообщение
            self.messagesDictionary[toId] = message
            
            self.messages = Array(self.messagesDictionary.values)
            self.messages.sort(by: { (message1, message2) -> Bool in
              return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
            })
          }
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
        }

      }, withCancel: nil)
      
  //    guard let uid = Auth.auth().currentUser?.uid else { return } // uid текущего юзера
  //
      // ветка нашего юзера, все сообщения
  //    let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
  //
  //    // проверяем новые ветки
  //    userMessagesRef.observe(.childAdded, with: { (snapshot) in
  //      print("1")
  //      let messageId = snapshot.key // ключ из ветки юзера
  //      // ссылка на это сообщение
  //      let messageRef = Database.database().reference().child("messages").child(messageId)
  //      // просматриваем значение сообщения
  //      messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
  //        // значение кладем в масив
  //        guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
  //
  //        let message = Message(dictionary: dictionary) // сообщения в масиве
  //
  //        if message.chatPartnerId() == self.user?.id { // проверка
  //          self.messages.append(message) // добавляем в новый масив
  //          DispatchQueue.main.async {
  //            self.collectionView?.reloadData()
  //          }
  //        }
  //      }, withCancel: nil)
  //    }, withCancel: nil)
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
