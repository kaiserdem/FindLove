//
//  FeedVC.swift
//  Find Love
//
//  Created by Kaiserdem on 03.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FeedVC: UIViewController, CellSubclassDelegate {

  @IBOutlet weak var postTextView: UITextView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var backTableView: UIView!
  @IBOutlet weak var addBtn: UIButton!
  
  let tableView = UITableView()
  
  var posts = [Post]()
  var postDictionary = [String: Post]()
  var user: User?
  
 
  override func viewDidLoad() {
        super.viewDidLoad()
    
    addBtn.setImage(UIImage(named: "add")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    addBtn.imageView?.tintColor = .white
    
    postTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPostBtnAction)))
    
    NotificationCenter.default.addObserver(self, selector: #selector(makeTransition(_:)), name: NSNotification.Name("makeTransitionToChat"), object: nil)
    
    uploadTableView()
    fetchUser()
    observePosts()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView.backgroundColor = .black
    tableView.allowsMultipleSelection = true
    postTextView.isEditable = false
    
  }
  
  func fetchUser() {
    // если currentUser 0 тогда выходим
    guard let uid = Auth.auth().currentUser?.uid else { return }
    // получаем uid по из базы данных, берем значение
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let user = User(dictionary: dictionary)
        self.setupNavBarWithUser(user)
      }
    }, withCancel: nil)
  }
  
  func setupNavBarWithUser(_ user: User) { //загрузить данные
    if let profileImageUrl = user.profileImageUrl {
      profileImageView.loadImageUsingCachWithUrlString(profileImageUrl)
    }
  }
  
  func writePost() {
    let vc = NewFeedPostVC(collectionViewLayout: UICollectionViewFlowLayout())
    present(vc, animated: true, completion: nil)
  }

  @IBAction func addPostBtnAction(_ sender: Any) {
    writePost()
  }
  
  func uploadTableView() {
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    
    backTableView.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: backTableView.topAnchor).isActive = true
    tableView.leftAnchor.constraint(equalTo: backTableView.leftAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: backTableView.bottomAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: backTableView.rightAnchor).isActive = true
    
    tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
  }
  
  func observePosts() {
    
    let ref = Database.database().reference().child("posts")
    ref.observe(.childAdded, with: { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        let post = Post(dictionary: dictionary)
        self.posts.append(post)
      }
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }, withCancel: nil)
  }
  
  @objc func makeTransition(_ notification: Notification) {
    if let toUser = notification.userInfo?["user"] as? User {
      showChatLogVCForUser(toUser)
    }
  }
  
  func showChatLogVCForUser(_ user: User?) {
    let vc = ReplyToFeedPostVC(collectionViewLayout: UICollectionViewFlowLayout())
    vc.user = user
    present(vc, animated: true, completion: nil)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func buttonTapped(cell: FeedCell) {
    
    guard let indexPath = self.tableView.indexPath(for: cell) else {
      return
    }
    print(indexPath.row)
    
  }
  
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
    
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let post = self.posts[indexPath.row]
    
    let postText = post.text
    let time = post.timestamp
    
    let view = OpenFeedPost(frame: self.view.frame)
    
    
    
    let ref = Database.database().reference().child("users").child(post.fromId!)
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        let userCurrent = User(dictionary: dictionary)
        view.user = userCurrent
        
        view.userNameLabel.text = dictionary["name"] as? String
      
        if let profileImageView = dictionary["profileImageUrl"] as? String {
          view.profileImageView.loadImageUsingCachWithUrlString(profileImageView)
        }
      }
    }, withCancel: nil)
    
    let timestampDate = Date(timeIntervalSince1970: (time?.doubleValue)!)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm:ss a"
    view.timeLabel.text = dateFormatter.string(from: timestampDate)
    view.postTextView.text = postText
    
    self.view.addSubview(view)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
    
    let post = posts[indexPath.row]
    cell.post = post
    cell.delegate = self
    cell.selectionStyle = .none

    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 115
  }
  
  
}
