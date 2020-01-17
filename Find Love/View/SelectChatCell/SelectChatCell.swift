//
//  SelectChatCell.swift
//  Find Love
//
//  Created by Kaiserdem on 12.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SelectChatCell: UITableViewCell {

  @IBOutlet weak var bottomLabel: UILabel!
  @IBOutlet weak var midleLabel: UILabel!
  @IBOutlet weak var topLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var subjectNameLabel: UITextView!
  @IBOutlet weak var descriptionLabel: UITextView!
  
  var group: Group? {
    didSet {
      //setupInfoCell()
    }
  }
  
  private func setupInfoCell() {
    
    let ref = Database.database().reference().child("groups")
    ref.observeSingleEvent(of: .value) { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        self.subjectNameLabel.text = dictionary["subject"] as? String
        self.descriptionLabel.text = dictionary["descriptions"] as? String
        self.bottomLabel.text = dictionary["countUsers"] as? String
        self.topLabel.text = dictionary["liked"] as? String
          
        if let iconImageView = dictionary["iconImageUrl"] as? String {
          self.iconImageView.loadImageUsingCachWithUrlString(iconImageView)
        } else {
          self.iconImageView.image = UIImage(named: "fire")
        }
        }
      }
    }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      contentView.backgroundColor = .black
    } else {
      contentView.backgroundColor = .black
    }
    
  }
    
}
