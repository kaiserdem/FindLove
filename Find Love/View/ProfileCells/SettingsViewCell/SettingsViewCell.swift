//
//  SettingsViewCell.swift
//  Find Love
//
//  Created by Kaiserdem on 03.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class SettingsViewCell: UITableViewCell {
  
  weak var delegate: ChangeBntCellDelegate?
  
  @IBOutlet weak var settingsBtn: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    //settingsBtn.backgroundColor = .clear
    //settingsBtn.layer.cornerRadius = 12
    //settingsBtn.layer.borderWidth = 2
    //settingsBtn.layer.borderColor = UIColor.white.cgColor
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
  
  @IBAction func settingsBtnAction(_ sender: Any) {
    print("settingsBtnAction")
    self.delegate?.settingsButtonTapped(cell: self)
  }
  
  
}
