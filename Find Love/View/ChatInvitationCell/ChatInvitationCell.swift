//
//  ChatInvitationCell.swift
//  Find Love
//
//  Created by Kaiserdem on 18.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class ChatInvitationCell: UITableViewCell {

  @IBOutlet weak var invitationLabel: UILabel!
  @IBOutlet weak var titleTextView: UITextView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    
    invitationLabel.layer.cornerRadius = 10
    
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
