//
//  SettingsSwitchCell.swift
//  Find Love
//
//  Created by Kaiserdem on 05.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class SettingsSwitchCell: UITableViewCell {

  @IBOutlet weak var outletLabel: UILabel!
  @IBOutlet weak var outletSwitch: UISwitch!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    
    
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
