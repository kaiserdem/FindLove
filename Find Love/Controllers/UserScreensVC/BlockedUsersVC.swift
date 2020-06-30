//
//  BlockedUsersVC.swift
//  Find Love
//
//  Created by Kaiserdem on 13.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

protocol ProtocolBlockCellDelegate: class {
  func blockButtonTapped(cell: BlockedUsersCell)
}

class BlockedUsersVC: UIViewController, ProtocolBlockCellDelegate {

  @IBOutlet weak var cencelBtn: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  var user: User?
  var users = [User]()
  
  let defaults = UserDefaults.standard
  lazy var arrayBlockUsers = defaults.stringArray(forKey: "arrayBlockUsers") ?? [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

      uploadTableView()
      fetchUser()
      cencelBtn.setImage(UIImage(named: "cancel")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      cencelBtn.tintColor = .white
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    tableView.allowsSelection = false
    tableView.tableFooterView = UIView() // убрать все что ниже
  }
  private func uploadTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.showsVerticalScrollIndicator = false
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)

    tableView.register(UINib(nibName: "BlockedUsersCell", bundle: nil), forCellReuseIdentifier: "BlockedUsersCell")

  }
  private func fetchUser() {
    if arrayBlockUsers.isEmpty == false {
      let ref = Database.database().reference().child("users")
      ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
        
        for child in snapshot.children {
          let snap = child as! DataSnapshot
          if (self?.arrayBlockUsers.contains(snap.key))! {
            if let dictionary = snap.value as? [String: AnyObject] {
              let user = User(dictionary: dictionary)
              user.id = snap.key
              self?.users.append(user)
            }
          }
        }
        self?.tableView.reloadData()
        }, withCancel: nil)
    }
  }
  
  func blockButtonTapped(cell: BlockedUsersCell) {
    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
     let user = users[indexPath.row]
    
    if arrayBlockUsers.contains(user.id!) {
      arrayBlockUsers.removeAll { $0 == user.id }
      cell.userBtn.setTitleColor(#colorLiteral(red: 0.2722153795, green: 0.2650756615, blue: 0.2733453801, alpha: 1), for: .normal)
      cell.userBtn.tintColor = .black
      defaults.set(arrayBlockUsers, forKey: "arrayBlockUsers")
    } else {
      arrayBlockUsers.append(user.id!)
      cell.userBtn.setTitleColor(.white, for: .normal)
      cell.userBtn.tintColor = .white

      defaults.set(arrayBlockUsers, forKey: "arrayBlockUsers")
    }
  }
  
  @IBAction func cencelBtnAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

  extension BlockedUsersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let user = users[indexPath.row]
      let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedUsersCell", for: indexPath) as! BlockedUsersCell
      cell.userBtn.setTitle(user.name, for: .normal)
      cell.delegate = self
      return cell
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 55
    }
  
}
