//
//  InformationViewCell.swift
//  Find Love
//
//  Created by Kaiserdem on 03.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class InformationViewCell: UITableViewCell {
  
  weak var delegate: ChangeBntCellDelegate?
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var changeDataBtn: UIButton!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var changeImageBtn: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    changeDataBtn.setImage(UIImage(named: "pen")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    changeDataBtn.imageView?.tintColor = .white
    
    changeImageBtn.setImage(UIImage(named: "add")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    changeImageBtn.imageView?.tintColor = .white
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
  
  @IBAction func changeDataAction(_ sender: Any) {
    print("changeDataAction")
    self.delegate?.changeInfoTapped(cell: self)
  }
  @IBAction func changeImageBtnAction(_ sender: Any) {
    print("changeImageBtnAction")
    self.delegate?.changeImageTapped(cell: self)
  }
  
}
