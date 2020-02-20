//
//  CustomNotificationView.swift
//  Find Love
//
//  Created by Kaiserdem on 20.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class CustomNotificationView: UIView {
  
  @IBOutlet var customNotificationView: UIView!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var textTextView: UITextView!

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      self.removeFromSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  
  func commonInit() {
    Bundle.main.loadNibNamed("CustomNotificationView", owner: self, options: nil)
    customNotificationView.fixInView(self)
    customNotificationView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.7)
    
    let opacity: CGFloat = 0.3
    let borderColor = UIColor.white
    backView.layer.borderWidth = 0.5
    backView.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
    textTextView.textAlignment = .center
  }
 
}
