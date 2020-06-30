//
//  StatusViewCell.swift
//  Find Love
//
//  Created by Kaiserdem on 03.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class StatusViewCell: UITableViewCell {
  
  weak var delegate: ProtocolProfileCellsDelegate?
  @IBOutlet weak var changeStatusBtn: UIButton!
  @IBOutlet weak var statusTextView: UITextView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      changeStatusBtn.setImage(UIImage(named: "pen")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      changeStatusBtn.imageView?.tintColor = .black

  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.delegate = nil
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      if selected {
        contentView.backgroundColor = .white
      } else {
        contentView.backgroundColor = .white
      }
    }
  
  @IBAction func statusBtnAction(_ sender: Any) {
    self.delegate?.changeStatusTapped(cell: self)
  }
    
}
