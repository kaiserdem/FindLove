//
//  ChatInvitationVC.swift
//  Find Love
//
//  Created by Kaiserdem on 18.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatInvitationVC: UIViewController {

  @IBOutlet weak var searchBtn: UIButton!
  @IBOutlet weak var cencelBtn: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  var groups = [Group]()
  var user: User?
  var currentUser: User?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      cencelBtn.setImage(UIImage(named: "cancel")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      cencelBtn.tintColor = .white
      
      searchBtn.setImage(UIImage(named: "search-1")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      searchBtn.tintColor = .white
      
      uploadTableView()
      fetchGroups()
      
      let objUser = UserDefaults.standard.retrieve(object: User.self, fromKey: "currentUserKey")
      currentUser = objUser
      
      

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
  
  private func fetchGroups() {
    
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
  
  private func sendChatInvintation(_ group: Group) {
 
    let ref = Database.database().reference().child("user-request")
    let toId = user!.id!
    let statusRequest = "0"
    let childRef = ref.childByAutoId()
    let fromUser = currentUser?.name
    let fromImageUrl = currentUser?.profileImageUrl
    let fromUserId = currentUser?.id
    let toGroup = group.subject
    
    let values = [ "fromUser": fromUser,
                   "fromImageUrl": fromImageUrl,
                   "fromUserId": fromUserId,
                   "toId": toId,
                   "toGroup": toGroup,
                   "statusRequest": statusRequest] as [String : Any]
    
    let chaild = ref.child(toId)
    let id = chaild.childByAutoId()
    id.updateChildValues(values) { [weak self ] (error, chaild) in
      if error != nil {
        print(error!)
        return
      } else {
        let customNotificationView = CustomNotificationView(frame: (self?.view.frame)!)
        customNotificationView.textTextView.text = "Запрос отправлен"
        self?.view.addSubview(customNotificationView)
      }
    }
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
    sendChatInvintation(group)
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
}


extension UIView {
  func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
    self.alpha = 0.0
    
    UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
      self.isHidden = false
      self.alpha = 1.0
    }, completion: completion)
  }
  
  func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
    self.alpha = 1.0
    
    UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
      self.isHidden = true
      self.alpha = 0.0
    }, completion: completion)
  }
}
