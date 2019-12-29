//
//  NewMessageVC.swift
//  Find Love
//
//  Created by Kaiserdem on 28.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class NewMessageVC: UIViewController {

  @IBOutlet weak var backViewTable: UIView!
  @IBOutlet weak var backBtn: UIButton!
  
  let tableView = UITableView()
  var messagesVC: MessagesVC?
  var users = [User]()
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    self.navigationController?.navigationBar.isHidden = true
    uploadTableView()
    fetchUser()
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
        self.users = [user]
        
        print(self.users)
        
        
        DispatchQueue.main.async { // на главном потоке асинхронно
          self.tableView.reloadData()
        }
      }
    }, withCancel: nil)
  }
  

  @IBAction func backBtnAction(_ sender: Any) {
  }
}

extension NewMessageVC: UITableViewDataSource, UITableViewDelegate {
  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let user = self.users[indexPath.row]
//    //showChatLogVCForUser(user)
//  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  5 //messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
    
    cell.userNameLabel.text = "1"
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65
  }
}
