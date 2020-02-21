//
//  ChatInvitationView.swift
//  Find Love
//
//  Created by Kaiserdem on 19.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatInvitationView: UIView {
  
  @IBOutlet var chatInvitationView: UIView!
  @IBOutlet weak var acceptBtn: UIButton!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var toGroupTextView: UITextView!
  @IBOutlet weak var userImageView: UIImageView!
  
  var requestId = ""
  var request: Request?
  
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
 
  private func actions(_ index: Int) {
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    let ref = Database.database().reference().child("user-request").child(uid).child(requestId)
    ref.observeSingleEvent(of: .value) { [weak self](snapshot) in
      
      if index == 1 {
        NotificationCenter.default.post(name: NSNotification.Name("toChatGroup"), object: nil, userInfo: ["group": self?.request?.toGroup! as Any])
         ref.removeValue()
        
      } else if index == 2 {
        ref.removeValue()
        
      } else {
        let values = ["statusRequest": "1"] as [String : Any]
        ref.updateChildValues(values)
      }
    }
  }
  
  @IBAction func acceptBtnAction(_ sender: Any) {
    actions(1)
  }
  @IBAction func refuseBtnAction(_ sender: Any) {
    actions(2)
  }
  @IBAction func laterBtnAction(_ sender: Any) {
    actions(3)
  }
  
}
