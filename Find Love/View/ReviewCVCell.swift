//
//  ReviewCVCell.swift
//  Find Love
//
//  Created by Kaiserdem on 06.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class ReviewCVCell: UICollectionViewCell {

  @IBOutlet weak var closeBtn: UIButton!
  @IBOutlet weak var messageBtn: UIButton!
  @IBOutlet weak var dislaikeBtn: UIButton!
  @IBOutlet weak var likeBtn: UIButton!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    
    
    closeBtn.layer.cornerRadius = (closeBtn.frame.size.height)/2
    closeBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    closeBtn.addShadow()
    
    likeBtn.layer.cornerRadius = (likeBtn.frame.size.height)/2
    likeBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    likeBtn.addShadow()
    
    
    dislaikeBtn.layer.cornerRadius = (dislaikeBtn.frame.size.height)/2
    dislaikeBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    dislaikeBtn.addShadow()
    
    messageBtn.layer.cornerRadius = (messageBtn.frame.size.height)/2
    messageBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    messageBtn.addShadow()
    

  }
  
  @IBAction func messageBtnAction(_ sender: Any) {
    messageBtn.blink()
  }
  
  @IBAction func dislikeBtnAction(_ sender: Any) {
    dislaikeBtn.blink()
  }
  
  @IBAction func likeBtnAction(_ sender: Any) {
    likeBtn.blink()
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    closeBtn.blink()
  }
}
