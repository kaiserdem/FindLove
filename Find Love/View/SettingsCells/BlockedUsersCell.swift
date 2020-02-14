//
//  BlockedUsersCell.swift
//  Find Love
//
//  Created by Kaiserdem on 13.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class BlockedUsersCell: UITableViewCell {

  @IBOutlet weak var widthConstraintUserBtn: NSLayoutConstraint!
  @IBOutlet weak var userBtn: UIButton!
  
  weak var delegate: ProtocolBlockCellDelegate?
  
  override func awakeFromNib() {
        super.awakeFromNib()
    

    userBtn.tintColor = .white
    
    let trailingAnchor  = (widthConstraintUserBtn.constant / 2) - 30
    
    userBtn.imageView?.leadingAnchor.constraint(equalTo: userBtn.centerXAnchor, constant: -trailingAnchor).isActive = true
    userBtn.imageView?.centerYAnchor.constraint(equalTo: userBtn.centerYAnchor, constant: 0.0).isActive = true
   
    userBtn.imageView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
    userBtn.imageView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
    userBtn.translatesAutoresizingMaskIntoConstraints = false
    userBtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.delegate = nil
  }

    
  @IBAction func blockTappedAction(_ sender: UIButton) {
    self.delegate?.blockButtonTapped(cell: self)
    userBtn.blink()
  }
}
