//
//  OpenFeedPost.swift
//  Find Love
//
//  Created by Kaiserdem on 16.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class OpenFeedPost: UIView {

  @IBOutlet weak var backView: UIView!
  @IBOutlet var openFeedPost: UIView!
  @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var blockButton: UIButton!
  @IBOutlet weak var complaintButton: UIButton!
  @IBOutlet weak var postTextView: UITextView!
  @IBOutlet weak var userDescriptionLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  
  var user: User?
  weak var feedVC: FeedVC?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    
    openFeedPost.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.9)
    backView.layer.borderWidth = 0.5
    
    let opacity:CGFloat = 0.3
    let borderColor = UIColor.white
    backView.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
    
    replyButton.applyGradient2(with: [#colorLiteral(red: 0.02352941176, green: 0.1764705882, blue: 0.5333333333, alpha: 1), #colorLiteral(red: 0.1529411765, green: 0.4509803922, blue: 0.8666666667, alpha: 1), #colorLiteral(red: 0.2196078431, green: 0.7921568627, blue: 0.7176470588, alpha: 1)], gradient: .horizontal)
    replyButton.layer.cornerRadius = 23
    postTextView.layer.cornerRadius = 6
    postTextView.sizeToFit()
    postTextView.layoutIfNeeded()
    textViewHeightConstraint.constant = postTextView.intrinsicContentSize.height
    
    profileImageView.layer.cornerRadius = 23
    profileImageView.layoutIfNeeded()
    
    blockButton.layer.cornerRadius = 18
    blockButton.layoutIfNeeded()
    
    complaintButton.layer.cornerRadius = 18
    complaintButton.layoutIfNeeded()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    Bundle.main.loadNibNamed("OpenFeedPost", owner: self, options: nil)
    openFeedPost.fixInView(self)
    
  }

  @IBAction func replyButtonAction(_ sender: UIButton) {
    
    NotificationCenter.default.post(name: NSNotification.Name("makeTransitionToChat"), object: nil, userInfo: ["user": user as Any])
    self.removeFromSuperview()
  }
  
  @IBAction func complaintButtonAction(_ sender: Any) {
  }
  
  @IBAction func blockButtonAction(_ sender: Any) {
  }
  
  @IBAction func closeButtonAction(_ sender: Any) {
    self.removeFromSuperview()
  }
  
}
