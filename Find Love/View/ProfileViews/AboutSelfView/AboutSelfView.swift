//
//  AboutSelfView.swift
//  Find Love
//
//  Created by Kaiserdem on 29.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class AboutSelfView: UIView {
  
  @IBOutlet var aboutSelfView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var aboutSelfSeparator: UIView!
  @IBOutlet weak var aboutSelfLabel: UILabel!
  @IBOutlet weak var aboutSelfTextView: UITextView!
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
    Bundle.main.loadNibNamed("AboutSelfView", owner: self, options: nil)
    aboutSelfView.fixInView(self)
    aboutSelfView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
  }
  
  private func setupBtnSettings() {
  }
  @IBAction func saveBtnAction(_ sender: Any) {
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    self.removeFromSuperview()
  }
  
}
