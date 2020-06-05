//
//  InformationViewCell.swift
//  Find Love
//
//  Created by Kaiserdem on 03.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class InformationViewCell: UITableViewCell {
  
  weak var delegate: ProtocolProfileCellsDelegate?
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var changeDataBtn: UIButton!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var changeImageBtn: UIButton!
  
  var user: User? {
    didSet {
      print(user?.name)
      print(user?.age)
      print(user?.gender)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    changeDataBtn.setImage(UIImage(named: "pen")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    changeDataBtn.imageView?.tintColor = .black
    
    changeImageBtn.setImage(UIImage(named: "add")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    changeImageBtn.imageView?.tintColor = .black
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
  
  @IBAction func changeDataAction(_ sender: Any) {
    self.delegate?.changeInfoTapped(cell: self)
  }
  @IBAction func changeImageBtnAction(_ sender: Any) {
    self.delegate?.changeImageTapped(cell: self)
  }
  
}
