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
  
  @IBOutlet weak var heightConstraintAboutSelfTextView: NSLayoutConstraint!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var aboutSelfSeparator: UIView!
  @IBOutlet weak var aboutSelfLabel: UILabel!
  @IBOutlet weak var aboutSelfTextView: UITextView!
  @IBOutlet weak var saveBtn: UIButton!
  @IBOutlet weak var closeBtn: UIButton!
  
  var beforeAboutSelfText = ""
  
  @IBOutlet weak var backView: UIView!
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
    Bundle.main.loadNibNamed("AboutSelfView", owner: self, options: nil)
    aboutSelfView.fixInView(self)
    aboutSelfView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
    
    saveBtn.isEnabled = false
    saveBtn.setTitleColor(.gray, for: .normal)
    
    let opacity:CGFloat = 0.3
    let borderColor = UIColor.white
    backView.layer.borderWidth = 0.5
    backView.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
  }
  func registerNotificationObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  @objc func keyboardWillAppear(_ notification: Notification) {
    if aboutSelfTextView.text.count > 5 {
      saveBtn.isEnabled = true
      saveBtn.setTitleColor(.white, for: .normal)
    }
    
    aboutSelfTextView.text = ""
    aboutSelfLabel.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    aboutSelfSeparator.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    
    aboutSelfLabel.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    aboutSelfSeparator.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
  }
  @objc func keyboardWillDisappear(_ notification: Notification) {
    aboutSelfLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    aboutSelfSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
  }
  
  @IBAction func saveBtnAction(_ sender: Any) {
    guard  let aboutSelfText = aboutSelfTextView.text else { // если пустые, принт, выходим
      print("Error: field is empty")
      return
    }
    if aboutSelfText.isEmpty == true {
      let view = CustomAlertWarning(frame: self.aboutSelfView.frame)
      view.textTextView.text = "Поле не может быть пустым"
      aboutSelfView.addSubview(view)
      return
    }
    if aboutSelfText.count < 5 {
      let view = CustomAlertWarning(frame: self.aboutSelfView.frame)
      view.textTextView.text = "Текст не может быть меньше 5 ти символов"
      aboutSelfView.addSubview(view)
      return
    }
    
    let ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
    
    if beforeAboutSelfText != aboutSelfText {
      let valuesText = ["aboutSelf": aboutSelfText] as [String : Any]
      ref.updateChildValues(valuesText)
      
    } else {
      saveBtn.isEnabled = false
      saveBtn.setTitleColor(.gray, for: .normal)
    }
    removeFromSuperview()
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    NotificationCenter.default.removeObserver(self)
    self.removeFromSuperview()
  }
  
}
