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

  @IBOutlet weak var backTableView: UIView!
  
  let tableView = UITableView()
  var posts = [Post]()
  var postDictionary = [String: Post]()
  var user: User?
  
 
  override func viewDidLoad() {
        super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(makeTransition(_:)), name: NSNotification.Name("makeTransitionToChat"), object: nil)
    
    uploadTableView()
    fetchUser()
    observePosts()
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView.backgroundColor = .black
    tableView.allowsMultipleSelection = false
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    //NotificationCenter.default.removeObserver(self)
  }
  
  func fetchUser() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let user = User(dictionary: dictionary)
        user.id = snapshot.key
      }
    }, withCancel: nil)
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
    tableView.showsVerticalScrollIndicator = false
    
    backTableView.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: backTableView.topAnchor).isActive = true
    tableView.leftAnchor.constraint(equalTo: backTableView.leftAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: backTableView.bottomAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: backTableView.rightAnchor).isActive = true
    
    tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
    tableView.register(UINib(nibName: "AddFeedPostCell", bundle: nil), forCellReuseIdentifier: "AddFeedPostCell")
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
     let toUser = notification.userInfo?["user"] as? User
      showChatLogVCForUser(toUser)
  }
  
  func showChatLogVCForUser(_ user: User?) {
    let vc = ReplyToFeedPostVC(collectionViewLayout: UICollectionViewFlowLayout())
    vc.user = user
    present(vc, animated: true, completion: nil)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func cellTappedLike(cell: FeedCell) {
    
    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
    
    let post = posts[indexPath.row]
    
    let ref = Database.database().reference().child("posts").child(post.postId!).child("likedUsers")
    
    if post.likedCount == 0 { // если лайков нет вообще // is work
      guard let uid = Auth.auth().currentUser?.uid else { return }
      
      let values = [uid: uid] as [String : Any]
      ref.updateChildValues(values)
      post.likedCount = 1
      cell.likeBtn.setImage(UIImage(named: "like")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      cell.likeBtn.tintColor = .red
      cell.countLikeLabel.text = String(describing: post.likedCount)
      
    } else { // какие то лайки есть
      let uid = Auth.auth().currentUser?.uid
      
      ref.observeSingleEvent(of: .value, with: { (snapshot) in
        
        var arrayLiked = [String]()
        
        for child in snapshot.children {
          let snap = child as! DataSnapshot
          let value = snap.value as! String
          arrayLiked.append(value) // масив всех лайков
        }
        if arrayLiked.contains(uid!) { // мой лайк уже есть, тогда удаляем
          if let index = arrayLiked.index(of: uid!) {
            arrayLiked.remove(at: index)
            cell.likeBtn.setImage(UIImage(named: "like")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            cell.likeBtn.tintColor = .white
            cell.countLikeLabel.text = String(describing: arrayLiked.count)
            post.likedCount = arrayLiked.count
            ref.child(uid!).removeValue()
          }
        } else { // лайки есть но моего нет
          arrayLiked.append(uid!)
          post.likedCount = arrayLiked.count
          cell.likeBtn.setImage(UIImage(named: "like")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
          cell.likeBtn.tintColor = .red
          cell.countLikeLabel.text = String(describing: arrayLiked.count)
          let values = [uid: uid] as! [String : Any]
          ref.updateChildValues(values)
        }
      }, withCancel: nil)
    }
    self.tableView.reloadData()
  }
  
  func cellTappedReplyMessage(cell: FeedCell) {
    guard let indexPath = self.tableView.indexPath(for: cell) else {
      return
    }
    let post = posts[indexPath.row]
    
    let ref = Database.database().reference().child("users").child(post.fromId!)
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let userCurrent = User(dictionary: dictionary)
        userCurrent.id = snapshot.key
        self.user = userCurrent
        
       // let send = post.text
       // NotificationCenter.default.post(name: NSNotification.Name("postTextToChat"), object: nil, userInfo: ["postText": send!])
        
        self.showChatLogVCForUser(self.user!)
        
      }
    }, withCancel: nil)
  }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddFeedPostCell", for: indexPath) as! AddFeedPostCell
      cell.contentView.backgroundColor = .black
      
      Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
        
        if let dictionary = snapshot.value as? [String: AnyObject] {
          let user = User(dictionary: dictionary)
          user.id = snapshot.key
          if let profileImageView = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCachWithUrlString(profileImageView)
          }
        }
      }, withCancel: nil)
      
    } else {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
      let post = posts[indexPath.row]
      cell.post = post
      cell.delegate = self
      cell.selectionStyle = .none
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if indexPath.row == 0 {
      writePost()
      return
    }
    
    let post = self.posts[indexPath.row]
    
    let postText = post.text
    let time = post.timestamp

    let view = OpenFeedPost(frame: self.view.frame)
    
    let ref = Database.database().reference().child("users").child(post.fromId!)
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        let userCurrent = User(dictionary: dictionary)
        userCurrent.id = snapshot.key
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 110
    } else {
      return 115
    }
  }
}
