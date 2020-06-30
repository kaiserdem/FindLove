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
  
//  var user: User? {
//    didSet {
//      loadCell()
//    }
//  }

    override func awakeFromNib() {
        super.awakeFromNib()
      
      postTextView.isEditable = false
      addBtn.setImage(UIImage(named: "add")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      addBtn.imageView?.tintColor = .black
      
//      let objUser = UserDefaults.standard.retrieve(object: User.self, fromKey: "currentUserKey")
//      user = objUser
      
  }
 
  override func layoutSubviews() {
    super.layoutSubviews()
    postTextView.centerVertically()
  }
  
  func configureWithItem(imageUrl: String) {
    DispatchQueue.main.async {
      self.profileImageView.loadImageUsingCache(imageUrl)
    }
  }
  
//  private func loadCell() {
//    DispatchQueue.main.async {
//
//      print(self.user?.profileImageUrl)
//      guard (self.user?.profileImageUrl) != nil else { return }
//      if let profileImageView = self.user!.profileImageUrl {
//        self.profileImageView.loadImageUsingCache(profileImageView)
//        self.profileImageView.image = nil
//      }
//    }
//  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    if selected {
      contentView.backgroundColor = .black
    } else {
      contentView.backgroundColor = .black
    }
  }
}
