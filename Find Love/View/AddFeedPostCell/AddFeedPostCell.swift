//
//  AddFeedPostCell.swift
//  Find Love
//
//  Created by Kaiserdem on 25.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class AddFeedPostCell: UITableViewCell {

  @IBOutlet weak var postTextView: UITextView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var addBtn: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
      postTextView.isEditable = false
      addBtn.setImage(UIImage(named: "add")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      addBtn.imageView?.tintColor = .white
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
