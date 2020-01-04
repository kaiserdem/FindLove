//
//  FeedCell.swift
//  Find Love
//
//  Created by Kaiserdem on 03.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
  
  
  @IBOutlet weak var replyBtn: UIButton!
  @IBOutlet weak var dislikeBtn: UIButton!
  @IBOutlet weak var likeBtn: UIButton!
  
  @IBOutlet weak var stateOnlineLabel: UIView!
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var postTextView: UITextView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    
    replyBtn.setImage(UIImage(named: "comment")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    replyBtn.tintColor = .white
    
    dislikeBtn.setImage(UIImage(named: "dislike")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    dislikeBtn.tintColor = .white
    
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
  
  @IBAction func dislikeBtnAction(_ sender: Any) {
    print("dislike Btn Action")
    
  }
}
