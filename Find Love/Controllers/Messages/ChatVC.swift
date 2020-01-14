//
//  ChatVC.swift
//  Find Love
//
//  Created by Kaiserdem on 11.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatVC: UIViewController {

  var groups = [Group]()
  
  var messages = [Message]()
  
  
  let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      uploadTableView()
      observeGroups()
      //uploadChatGroup()
  }
  
  func uploadTableView() {
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .black
    self.view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
    tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
    tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
    tableView.register(UINib(nibName: "SelectChatCell", bundle: nil), forCellReuseIdentifier: "SelectChatCell")
  }

  func uploadChatGroup() {
    let ref = Database.database().reference().child("groups")
    let childRef = ref.childByAutoId()
    print(childRef)
    
    let subject = "Вирт-чат для девушек"
    let descriptions = "Парням вход закрыт"
    let countUsers = 3
    let liked = 5
    
    let values = ["subject": subject, "descriptions": descriptions, "countUsers": countUsers, "liked": liked] as [String : Any]

    ref.child(subject).updateChildValues(values)
    
    let values2  = ["dscds":"dscsdc"] as [String : Any]
    
    ref.child(subject).child("messages").updateChildValues(values2) { (error, ref) in
      if error != nil {
        print(error!)
        return
      }
    }
  }
  
  func observeGroups() {
    
    let ref = Database.database().reference().child("groups")
    ref.observe(.childAdded, with: { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        let group = Group(dictionary: dictionary)
        self.groups.append(group)
      }
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }, withCancel: nil)
  }

}

extension ChatVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SelectChatCell", for: indexPath) as! SelectChatCell

    let group = groups[indexPath.row]

    cell.subjectNameLabel.text = group.subject
    cell.descriptionLabel.text = group.descriptions
    cell.bottomLabel.text = String(describing: group.countUsers!)
    cell.topLabel.text = String(describing: group.liked!)
    
    if let profileImageView = group.iconImageUrl {
      cell.iconImageView.loadImageUsingCachWithUrlString(profileImageView)
    } else {
      cell.iconImageView.image = UIImage(named: "fire")
    }
    
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  groups.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 85
  }
 
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let group = self.groups[indexPath.row]
    
    
    let ref = Database.database().reference().child("groups").child(group.subject!)
    ref.observe(.value, with: { (snapshot) in
      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
      
      let groupDict = Group(dictionary: dictionary)
      
      let vc = ChatWriteMessageVC(collectionViewLayout: UICollectionViewFlowLayout())
      vc.group = groupDict
      self.present(vc, animated: true, completion: nil)
      
    }, withCancel: nil)
  }
  
}
