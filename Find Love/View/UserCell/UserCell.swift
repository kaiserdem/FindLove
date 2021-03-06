//
//  UserCell.swift
//  Find Love
//
//  Created by Kaiserdem on 27.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserCell: UITableViewCell {
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var lastMessagesLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView!

  var message: Message? {
    didSet {
      setupNameAndProfileImage()
    }
  }
  
  private func setupNameAndProfileImage() {
    
    if let id = message?.chatPartnerId() { // если есть такой
      let ref = Database.database().reference().child("users").child(id) // айди всех
      ref.observeSingleEvent(of: .value, with: { (snapshot) in
        
        if let dictionary = snapshot.value as? [String: AnyObject] {
          self.userImageView.image = UIImage(named: "user")
          self.userImageView.contentMode = .scaleAspectFit
          self.userNameLabel.text = dictionary["name"] as? String
          self.lastMessagesLabel.text = self.message!.text
          self.timeLabel.text = self.setFormatDislayedTimeAndDate(from: self.message!.timestamp as! TimeInterval, withString: true)
          if let profileImageView = dictionary["profileImageUrl"] as? String {
            self.userImageView.loadImageUsingCache(profileImageView)
          }
        }
      }, withCancel: nil)
    }
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
