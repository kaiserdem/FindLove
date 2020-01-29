//
//  StatusView.swift
//  Find Love
//
//  Created by Kaiserdem on 29.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class StatusView: UIView {
  
  @IBOutlet var statusView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var statusSeparator: UIView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var statusTextView: UITextView!
  
  
  @IBOutlet weak var saveBtn: UIButton!
  
  @IBOutlet weak var closeBtn: UIButton!
 
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    
    setupBtnSettings()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("StatusView", owner: self, options: nil)
    statusView.fixInView(self)
    statusView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
  }
  
  private func setupBtnSettings() {
    
    
  }
  @IBAction func saveBtnAction(_ sender: Any) {
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    self.removeFromSuperview()
  }
}
