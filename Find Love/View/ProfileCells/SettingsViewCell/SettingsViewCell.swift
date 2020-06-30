//
//  SettingsViewCell.swift
//  Find Love
//
//  Created by Kaiserdem on 03.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class SettingsViewCell: UITableViewCell {
  
  weak var delegate: ProtocolProfileCellsDelegate?
  
  @IBOutlet weak var settingsBtn: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let image = UIImage(named: "right")
    let buttonView = UIImageView(image: image)
    buttonView.contentMode = UIView.ContentMode.scaleAspectFit
    buttonView.layer.masksToBounds = true
    settingsBtn.tintColor = .black
    settingsBtn.addSubview(buttonView)
    
    buttonView.rightAnchor.constraint(equalTo: settingsBtn.rightAnchor).isActive = true
    buttonView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    buttonView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    buttonView.centerYAnchor.constraint(equalTo: settingsBtn.centerYAnchor, constant: 0).isActive = true
    buttonView.translatesAutoresizingMaskIntoConstraints = false
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
  
  @IBAction func settingsBtnAction(_ sender: Any) {
    self.delegate?.settingsButtonTapped(cell: self)
  }
  
  
}
