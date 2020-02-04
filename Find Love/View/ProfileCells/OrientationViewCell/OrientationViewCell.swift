//
//  OrientationViewCell.swift
//  Find Love
//
//  Created by Kaiserdem on 03.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class OrientationViewCell: UITableViewCell {
  
  weak var delegate: ChangeBntCellDelegate?
  
  @IBOutlet weak var changeOrientationBtn: UIButton!
  @IBOutlet weak var orientationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
      changeOrientationBtn.setImage(UIImage(named: "pen")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      changeOrientationBtn.imageView?.tintColor = .white
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
  
  @IBAction func changeOrientationBtnAction(_ sender: Any) {
    print("changeOrientationBtnAction")
    self.delegate?.changeOrientationTapped(cell: self)
  }
    
}
