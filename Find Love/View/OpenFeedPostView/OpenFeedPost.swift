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
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  
  var user: User?
  weak var feedVC: FeedVC?
  let defaults = UserDefaults.standard
  lazy var arrayBlockUsers = defaults.stringArray(forKey: "arrayBlockUsers") ?? [String]()
  
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
    
    print(arrayBlockUsers.count)
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
    if user?.id != nil {
      if arrayBlockUsers.isEmpty == true { // если пустой тодобавялем
        arrayBlockUsers.append((user?.id!)!)
        blockButton.backgroundColor = #colorLiteral(red: 0.2028513703, green: 0.2187514845, blue: 0.2407456104, alpha: 1)
        blockButton.setTitleColor(#colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1), for: .normal)
        blockButton.setTitle("Разблокировать", for: .normal)
      } else {                             // если не пусто то провкряем на наличие
        if arrayBlockUsers.contains((user?.id)!) { // если уже есть то удаляем
          if let index = arrayBlockUsers.index(of: (user?.id)!) {
            arrayBlockUsers.remove(at: index)
            blockButton.backgroundColor = #colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1)
            blockButton.setTitleColor(#colorLiteral(red: 0.2028513703, green: 0.2187514845, blue: 0.2407456104, alpha: 1), for: .normal)
            blockButton.setTitle("Заблокировать", for: .normal)
          }
        } else {
          arrayBlockUsers.append((user?.id!)!)// если нет то добавляем
          blockButton.backgroundColor = #colorLiteral(red: 0.2028513703, green: 0.2187514845, blue: 0.2407456104, alpha: 1)
          blockButton.setTitleColor(#colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1), for: .normal)
          blockButton.setTitle("Разблокировать", for: .normal)
        }
      }
      defaults.set(arrayBlockUsers, forKey: "arrayBlockUsers")
    }
    print("OpenFeedPost, block users: \(arrayBlockUsers.count)")
  }
  
  @IBAction func closeButtonAction(_ sender: Any) {
     NotificationCenter.default.post(name: NSNotification.Name("reloadTableView"), object: nil, userInfo: nil)
    self.removeFromSuperview()
  }
  
}
