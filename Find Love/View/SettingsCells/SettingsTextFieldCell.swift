//
//  SettingsTextFieldCell.swift
//  Find Love
//
//  Created by Kaiserdem on 05.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class SettingsTextFieldCell: UITableViewCell {

  @IBOutlet weak var outletTextField: UITextField!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
