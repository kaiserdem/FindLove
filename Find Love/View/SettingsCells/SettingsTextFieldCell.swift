//
//  SettingsTextFieldCell.swift
//  Find Love
//
//  Created by Kaiserdem on 05.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class SettingsTextFieldCell: UITableViewCell {
  
  weak var delegate: ProtocolSettingsCellDelegate?
  
  @IBOutlet weak var outletTextField: UITextField!
  
  var button = UIButton()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let customView = UIView(frame: CGRect(x: 0, y: 0, width: (outletTextField.frame.maxX), height: 50))
    customView.backgroundColor = #colorLiteral(red: 0.9254091382, green: 0.9255421162, blue: 0.9253799319, alpha: 1)
    
    button.frame = CGRect(x: 20, y: 7, width: outletTextField.frame.maxX - 20, height: 36)
    button.backgroundColor = .white
    button.setTitleColor(.black, for: .normal)
    button.layer.cornerRadius = 6
    button.layer.borderWidth = 1
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    button.layer.borderColor = UIColor.gray.cgColor
    button.setTitle("Сохранить", for: .normal)
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    customView.addSubview(button)
    outletTextField.inputAccessoryView = customView
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  @objc func buttonAction(sender: UIButton!) {
    self.delegate?.saveTextFieldTapped(cell: self, string: outletTextField.text!)
    button.blink()
    
  }
  
}
