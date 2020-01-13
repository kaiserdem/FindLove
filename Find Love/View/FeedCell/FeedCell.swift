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
  
  @IBOutlet weak var timeDataLabel: UILabel!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var viewsBtnLabel: UIButton!
  
  @IBOutlet weak var replyBtn: UIButton!
  @IBOutlet weak var likeBtn: UIButton!
  
  @IBOutlet weak var stateOnlineLabel: UIView!
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var postTextView: UITextView!
  
  @IBOutlet weak var backGradientView: UIView!
  
  var post: Post? {
    didSet {
      setupNameAndProfileImage()
    }
  }
  
  private func setupNameAndProfileImage() {

      let ref = Database.database().reference().child("posts")
      ref.observeSingleEvent(of: .value, with: { (snapshot) in

        if let dictionary = snapshot.value as? [String: AnyObject] {
         
          self.postTextView.text = self.post!.text
          if let fromId = self.post!.fromId {
            let ref = Database.database().reference().child("users").child(fromId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
              
              if let dictionary = snapshot.value as? [String: AnyObject] {
                self.nameLabel.text = dictionary["name"] as? String
                
                if let profileImageView = dictionary["profileImageUrl"] as? String {
                  self.profileImageView.loadImageUsingCachWithUrlString(profileImageView)
                }
              }
            }, withCancel: nil)
          }
        }
      }, withCancel: nil)
    
    let userPost = ref.child(self.post!.fromId!)
    
    userPost.observeSingleEvent(of: .childAdded, with: { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
      }
    }, withCancel: nil)
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

  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
  @IBAction func replyBtnAction(_ sender: Any) {
    print("reply Btn Action")
    
  }
  
  @IBAction func likeBtnAction(_ sender: Any) {
    print("like Btn Action")
    
  }
  
}
