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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    postTextView.centerVertically()
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

extension UITextView {
  
  func centerVertically() {
    let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
    let size = sizeThatFits(fittingSize)
    let topOffset = (bounds.size.height - size.height * zoomScale) / 2
    let positiveTopOffset = max(1, topOffset)
    contentOffset.y = -positiveTopOffset
  }
  
}
