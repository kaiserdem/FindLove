//
//  ChatWithStrangerCell.swift
//  Find Love
//
//  Created by Kaiserdem on 26.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class ChatWithStrangerCell: UITableViewCell {

  @IBOutlet weak var backContentView: UIView!
  @IBOutlet weak var arrowDoneButton: UIButton!
  @IBOutlet weak var textCellLabel: UILabel!
  @IBOutlet weak var imageViewButtonCell: UIButton!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    
    backContentView.applyGradient2(with: [#colorLiteral(red: 0.01959940786, green: 0.156984397, blue: 0.4753301834, alpha: 1), #colorLiteral(red: 0.1285700801, green: 0.3775917176, blue: 0.7260313053, alpha: 1), #colorLiteral(red: 0.1967329752, green: 0.7184665444, blue: 0.6488609484, alpha: 1)], gradient: .horizontal)
    
    imageViewButtonCell.setImage(UIImage(named: "loveChat")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    imageViewButtonCell.tintColor = .white
    
    arrowDoneButton.setImage(UIImage(named: "arrowDone")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    arrowDoneButton.tintColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


  }
    
}
