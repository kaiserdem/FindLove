//
//  AboutSelfViewCell.swift
//  Find Love
//
//  Created by Kaiserdem on 03.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class AboutSelfViewCell: UITableViewCell {
  
  weak var delegate: ChangeBntCellDelegate?
  
  @IBOutlet weak var changeAboutSelfBtn: UIButton!
  @IBOutlet weak var aboutSelfTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
      changeAboutSelfBtn.setImage(UIImage(named: "pen")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      changeAboutSelfBtn.imageView?.tintColor = .white
    
    }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.delegate = nil
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      if selected {
        contentView.backgroundColor = .black
      } else {
        contentView.backgroundColor = .black
      }
    }
  
  @IBAction func aboutSelfBtnAction(_ sender: Any) {
    self.delegate?.changeAboutSelfTapped(cell: self)
  }
    
}
