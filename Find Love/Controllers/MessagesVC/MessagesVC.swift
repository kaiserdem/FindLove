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
  
  @IBOutlet weak var menyBtn: UIButton!
  @IBOutlet weak var newMessageBtn: UIButton!
  @IBOutlet weak var backViewTable: UIView!
  
  
  let tableView = UITableView()
  let cellId = "Cell"
  var users = [User]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchUser()
    uploadTableView()
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
        
        print(self.users)
        DispatchQueue.main.async { // на главном потоке асинхронно
          self.tableView.reloadData()
        }
      }
    }, withCancel: nil)
  }
  
  @IBAction func menyBtnAction(_ sender: Any) {
    let vc = MenuVC.init(nibName: "MenuVC", bundle: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  @IBAction func newMessageBtnAction(_ sender: Any) {
    //let vc = ChatLogVC.init(nibName: "ChatLogVC", bundle: nil)
    let vc = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
    navigationController?.pushViewController(vc, animated: true)
  }
  
}

extension MessagesVC: UITableViewDataSource, UITableViewDelegate {
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
    
    let user = users[indexPath.row]
    cell.userImageView.image = UIImage(named: "user")
    cell.userImageView.contentMode = .scaleAspectFit
    cell.userNameLabel.text = user.name
    cell.lastMessagesLabel.text = user.email
    
    if let profileImageView = user.profileImageUrl {
      cell.userImageView.loadImageUsingCachWithUrlString(profileImageView)
    }
    return cell
  }
  
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65
  }
}
