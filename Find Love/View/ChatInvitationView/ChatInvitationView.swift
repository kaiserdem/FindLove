//
//  ChatInvitationView.swift
//  Find Love
//
//  Created by Kaiserdem on 19.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class ChatInvitationView: UIView {
  
  @IBOutlet var chatInvitationView: UIView!
  @IBOutlet weak var acceptBtn: UIButton!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var toGroupTextView: UITextView!
  @IBOutlet weak var userImageView: UIImageView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  
  func commonInit() {
    Bundle.main.loadNibNamed("ChatInvitationView", owner: self, options: nil)
    chatInvitationView.fixInView(self)
    chatInvitationView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.7)
    
    acceptBtn.layer.cornerRadius = 10
    userImageView.layer.cornerRadius = 40
    
    
    let opacity: CGFloat = 0.3
    let borderColor = UIColor.white
    backView.layer.borderWidth = 0.5
    backView.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
  }
  
  @IBAction func refuseBtnAction(_ sender: Any) {
    removeFromSuperview()
  }
  @IBAction func laterBtnAction(_ sender: Any) {
    removeFromSuperview()
  }
  @IBAction func acceptBtnAction(_ sender: Any) {
    removeFromSuperview()
  }
  
}
