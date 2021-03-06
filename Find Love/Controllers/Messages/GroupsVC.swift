//
//  GroupsVC.swift
//  Find Love
//
//  Created by Kaiserdem on 11.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GroupsVC: UIViewController {

  var groups = [Group]()
  let defaults = UserDefaults.standard
  lazy var arrayBlockUsers = defaults.stringArray(forKey: "arrayBlockUsers") ?? [String]()

  let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      uploadTableView()
      observeGroups()
      //uploadChatGroup() // добавить группу
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    observeChatInvitation()
  }
 
  private func uploadTableView() {
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .black
    self.view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
    tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
    tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)
    tableView.register(UINib(nibName: "SelectChatCell", bundle: nil), forCellReuseIdentifier: "SelectChatCell")
    
  }
  
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

  private func uploadChatGroup() {
    let ref = Database.database().reference().child("groups")
    let subject = "Луганск - Донецк"
    let descriptions = ""
    let countUsers = 61
    let liked = 33
    
    let values = ["subject": subject, "descriptions": descriptions, "countUsers": countUsers, "liked": liked] as [String : Any]
   
    ref.child(subject).updateChildValues(values) { (error, ref) in
      if error != nil {
        print(error!)
        return
      }
      print("Group was created")
    }
  }
  
  private func observeGroups() {
    
    let ref = Database.database().reference().child("groups")
    ref.observe(.childAdded, with: { [weak self] (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        let group = Group(dictionary: dictionary)
        self?.groups.append(group)
      }
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }, withCancel: nil)
  }

}

extension GroupsVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SelectChatCell", for: indexPath) as! SelectChatCell

    let group = groups[indexPath.row]

    cell.subjectNameLabel.text = group.subject
    cell.descriptionLabel.text = group.descriptions
    
    if let profileImageView = group.iconImageUrl {
      cell.iconImageView.loadImageUsingCache(profileImageView)
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
    ref.observe(.value, with: { [weak self] (snapshot) in
      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
      
      let groupDict = Group(dictionary: dictionary)
      
      let vc = ChatGroupCVC(collectionViewLayout: UICollectionViewFlowLayout())
      vc.group = groupDict
      self?.present(vc, animated: true, completion: nil)
      
    }, withCancel: nil)
  }
  
}

