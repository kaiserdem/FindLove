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
    registerNotificationObservers()
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
  
  func registerNotificationObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  
  @objc func keyboardWillAppear(_ notification: Notification) {
    statusLabel.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    statusSeparator.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
  }
  
  @objc func keyboardWillDisappear(_ notification: Notification) {
    statusLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    statusSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
  }
  
  @IBAction func saveBtnAction(_ sender: Any) {
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    NotificationCenter.default.removeObserver(self)
    self.removeFromSuperview()
  }
}
