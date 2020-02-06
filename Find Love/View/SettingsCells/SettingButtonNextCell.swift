//
//  SettingButtonNextCell.swift
//  Find Love
//
//  Created by Kaiserdem on 05.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class SettingButtonNextCell: UITableViewCell {

  @IBOutlet weak var nextButtonOutlet: UIButton!
  
  weak var delegate: ProtocolSettingsCellDelegate?
  
  override func awakeFromNib() {
        super.awakeFromNib()

    let image = UIImage(named: "right")
    nextButtonOutlet.tintColor = .white
    let buttonView = UIImageView(image: image)
    buttonView.contentMode = UIView.ContentMode.scaleAspectFit
    buttonView.layer.masksToBounds = true
    nextButtonOutlet.addSubview(buttonView)
    
    buttonView.rightAnchor.constraint(equalTo: nextButtonOutlet.rightAnchor).isActive = true
    
    buttonView.widthAnchor.constraint(equalToConstant: 25).isActive = true
    buttonView.heightAnchor.constraint(equalToConstant: 25).isActive = true
    
    buttonView.centerYAnchor.constraint(equalTo: nextButtonOutlet.centerYAnchor).isActive = true
    buttonView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.delegate = nil
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
  
  @IBAction func nextButton(_ sender: UIButton) {
    self.delegate?.nextButtonTapped(cell: self)
    nextButtonOutlet.blink()
  }
  
}
