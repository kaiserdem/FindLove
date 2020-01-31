//
//  CustomAlertWarning.swift
//  Find Love
//
//  Created by Kaiserdem on 31.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//
import UIKit

class CustomAlertWarning: UIView {
  
  @IBOutlet var customAlertWarning: UIView!
  @IBOutlet weak var closeBtn: UIButton!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var textTextView: UITextView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
   
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  
  func commonInit() {
    Bundle.main.loadNibNamed("CustomAlertWarning", owner: self, options: nil)
    customAlertWarning.fixInView(self)
    customAlertWarning.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.7)
   
    
    let opacity: CGFloat = 0.3
    let borderColor = UIColor.white
    backView.layer.borderWidth = 0.5
    backView.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    removeFromSuperview()
  }
  
}
