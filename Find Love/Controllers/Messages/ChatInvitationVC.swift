//
//  ChatInvitationVC.swift
//  Find Love
//
//  Created by Kaiserdem on 18.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class ChatInvitationVC: UIViewController {

  @IBOutlet weak var searchBtn: UIButton!
  @IBOutlet weak var cencelBtn: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  var groups = [Group]()
  var user: User?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      cencelBtn.setImage(UIImage(named: "cancel")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      cencelBtn.tintColor = .white
      
      searchBtn.setImage(UIImage(named: "search-1")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      searchBtn.tintColor = .white
      
      uploadTableView()
      observeGroups()

    }
  
  func uploadTableView() {
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .black
    self.view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 104).isActive = true
    tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
    tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    tableView.register(UINib(nibName: "ChatInvitationCell", bundle: nil), forCellReuseIdentifier: "ChatInvitationCell")
    
  }
  
  func observeGroups() {
    
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
    

  @IBAction func searchButtonAction(_ sender: Any) {
    
  }
  
  @IBAction func closeButtonAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

}
extension ChatInvitationVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  groups.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatInvitationCell", for: indexPath) as! ChatInvitationCell
    
    let group = groups[indexPath.row]
    
    cell.titleTextView.text = group.subject
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let group = groups[indexPath.row]
    
    print(group.subject)
    
//    let ref = Database.database().reference().child("messages")
//    let childRef = ref.childByAutoId()
//    let toId = user!.id!
//    let fromId = Auth.auth().currentUser!.uid
//    let timestamp = Int(Date().timeIntervalSince1970)
//    let stausMessage = "3"
//    let text = group.subject
//
//    var values = [ "toId": toId, "fromId": fromId, "timestamp": timestamp, text: "text", "stausMessage": stausMessage] as! [String : Any]
//
//    childRef.updateChildValues(values) { (error, ref) in
//      if error != nil {
//        print(error!)
//        return
//      }
//    }
//
//
//    let refFromTo = Database.database().reference().child("user-messages").child(fromId).child(toId)
//
//    let messageId = childRef.key
//    let values2 = [messageId: 1] as! [String : Any]
//
//    refFromTo.updateChildValues(values2) { (error, ref) in
//      if error != nil {
//        print(error!)
//        return
//      }
//    }
//
//    let refToFrom = Database.database().reference().child("user-messages").child(toId).child(fromId)
//
//    let messageId3 = childRef.key
//    let values3 = [messageId3: 1] as! [String : Any]
//
//    refToFrom.updateChildValues(values3) { (error, ref) in
//      if error != nil {
//        print(error!)
//        return
//      }
//    }
  }
  
}
