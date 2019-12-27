//
//  MessagesTableVC.swift
//  Find Love
//
//  Created by Kaiserdem on 26.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableVC: UITableViewController {
  
  let cellId = "Cell"
  
  var users = [User]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchUser()
//    navigationController?.navigationBar.isHidden = false
//
//    navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
    
    tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
  }
  
//  func fetchUser() {
//
//    Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
//      if let dictionary = snapshot.value as? [String: AnyObject] {
//
//        print(snapshot)
//         let user = User(dictionary: dictionary)
//        //self.users.append(user)
//        //print(user.name as Any)
//      }
//    }, withCancel: nil)
//  }
  
  func fetchUser() { // выбрать пользователя
    Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let user = User(dictionary: dictionary) // пользователь
        user.id = snapshot.key
        
        self.users.append(user) // добавляем в масив
        
        print(self.users)
        DispatchQueue.main.async { // на главном потоке асинхронно
          self.tableView.reloadData()
        }
      }
    }, withCancel: nil)
  }
  
  @objc func cancel() {
    let controll = MenuVC.init(nibName: "MenuVC", bundle: nil)
    navigationController?.pushViewController(controll, animated: true)
  }
  
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return users.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
    
    let user = users[indexPath.row]
    cell.userImageView.image = UIImage(named: "user")
    cell.userNameLabel.text = user.name
    cell.lastMessagesLabel.text = user.email
    return cell
  }
  
}
