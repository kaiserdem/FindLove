//
//  FeedCell.swift
//  Find Love
//
//  Created by Kaiserdem on 03.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class FeedCell: UITableViewCell {
  
  weak var delegate: CellSubclassDelegate?
  
  @IBOutlet weak var statusOnlineLabel: UILabel!
  @IBOutlet weak var timeDateLabel: UILabel!
  @IBOutlet weak var countLikeLabel: UILabel!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var viewsBtnLabel: UIButton!
  @IBOutlet weak var replyBtn: UIButton!
  @IBOutlet weak var likeBtn: UIButton!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var userProfileImageView: UIImageView!
  @IBOutlet weak var postTextView: UITextView!
  @IBOutlet weak var backGradientView: UIView!
  
  var post: Post? {
    didSet {
      uploadPostData()
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.delegate = nil
    self.userProfileImageView.image = nil
  }
  
  private func uploadPostData() {
    
    self.postTextView.text = self.post!.text // текст
    
    self.timeDateLabel.text = setFormatDislayedTimeAndDate(from: self.post!.timestamp as! TimeInterval, withString: true)
    
    if let fromId = self.post!.fromId {
      let ref = Database.database().reference().child("users").child(fromId)
      ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
        
        if let dictionary = snapshot.value as? [String: AnyObject] {
          self?.nameLabel.text = dictionary["name"] as? String
          
          if let status = dictionary["statusOnline"] as? String {
            
             self?.statusOnlineLabel.text = self?.statusOnlineValidator(string: status)
          } else {
            self?.statusOnlineLabel.text = ""
          }
          
          if let profileImageView = dictionary["profileImageUrl"] as? String {
            self?.userProfileImageView.loadImageUsingCache(profileImageView)
          }
  
        }
      }, withCancel: nil)
    }
    
    let ref = Database.database().reference().child("posts").child(post!.postId!).child("likedUsers")
    ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in

      var arrayLiked = [String]()

      for child in snapshot.children {
        let snap = child as! DataSnapshot
        let value = snap.value as! String
        arrayLiked.append(value)

        guard let uid = Auth.auth().currentUser?.uid else { return }

        if arrayLiked.contains(uid) {
          self?.likeBtn.setImage(UIImage(named: "like")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
          self?.likeBtn.tintColor = .red
        } else {
          self?.likeBtn.setImage(UIImage(named: "like")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
          self?.likeBtn.tintColor = .white
        }
      }
      if arrayLiked.count == 0 {
        self?.countLikeLabel.isHidden = true
      } else {
        self?.countLikeLabel.isHidden = false
        self?.countLikeLabel.text = String(describing: arrayLiked.count)
        self?.post!.likedCount = arrayLiked.count
      }
    }, withCancel: nil)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    postTextView.centerVertically()
  }

  
  override func awakeFromNib() {
        super.awakeFromNib()
    
    backView.applyGradient2(with: [#colorLiteral(red: 0.01959940786, green: 0.156984397, blue: 0.4753301834, alpha: 1), #colorLiteral(red: 0.1285700801, green: 0.3775917176, blue: 0.7260313053, alpha: 1), #colorLiteral(red: 0.1967329752, green: 0.7184665444, blue: 0.6488609484, alpha: 1)], gradient: .horizontal)
    
    backGradientView.applyGradient2(with: [#colorLiteral(red: 0.01323446935, green: 0.1060034673, blue: 0.3209659593, alpha: 1), #colorLiteral(red: 0.09266551329, green: 0.2721452013, blue: 0.5232793159, alpha: 1), #colorLiteral(red: 0.1401252464, green: 0.5117357752, blue: 0.4621584164, alpha: 1)], gradient: .horizontal)
    backGradientView.layer.cornerRadius = 8
    
    replyBtn.setImage(UIImage(named: "comment")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    replyBtn.tintColor = .white
    
    viewsBtnLabel.setImage(UIImage(named: "eye")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    viewsBtnLabel.tintColor = .white
    
    likeBtn.setImage(UIImage(named: "like")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    likeBtn.tintColor = .white
    
    postTextView.isEditable = false
    postTextView.isScrollEnabled = false
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    tapGestureRecognizer.numberOfTapsRequired = 1
    userProfileImageView.addGestureRecognizer(tapGestureRecognizer)
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      if selected {
        contentView.backgroundColor = .black
      } else {
        contentView.backgroundColor = .black
      }
    }
    
  @IBAction func replyBtnAction(_ sender: Any) {
    self.delegate?.cellTappedReplyMessage(cell: self)
  }
  
  @IBAction func likeBtnAction(_ sender: Any) {
    self.delegate?.cellTappedLike(cell: self)
  }
  
  @objc func imageTapped(_ sender: UITapGestureRecognizer) {
    self.delegate?.cellTappedImageProfile(cell: self)
  }

}
