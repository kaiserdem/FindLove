//
//  SearchStrangerForChatView.swift
//  Find Love
//
//  Created by Kaiserdem on 26.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class SearchStrangerForChatView: UIView {
  
  @IBOutlet var searchStrangerForChatView: UIView!
  
  @IBOutlet weak var backGradientView: UIView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var randomButton: UIButton!
  @IBOutlet weak var menButton: UIButton!
  @IBOutlet weak var womenButton: UIButton!
  
  @IBOutlet weak var randomLabel: UILabel!
  @IBOutlet weak var menLabel: UILabel!
  @IBOutlet weak var womenLabel: UILabel!
  
  @IBOutlet weak var searchDoneBtn: UIButton!

//  var user: User?
//  weak var feedVC: FeedVC?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    
    searchDoneBtn.applyGradient2(with: [#colorLiteral(red: 0.02352941176, green: 0.1764705882, blue: 0.5333333333, alpha: 1), #colorLiteral(red: 0.1529411765, green: 0.4509803922, blue: 0.8666666667, alpha: 1), #colorLiteral(red: 0.2196078431, green: 0.7921568627, blue: 0.7176470588, alpha: 1)], gradient: .horizontal)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("SearchStrangerForChatView", owner: self, options: nil)
    searchStrangerForChatView.fixInView(self)
  }
  

  
  @IBAction func closeBtnAction(_ sender: Any) {
    self.removeFromSuperview()
  }
  
  @IBAction func searchBtnAction(_ sender: Any) {
  }
  
  @IBAction func womanBtnAction(_ sender: Any) {
  }
  
  @IBAction func manBtnAction(_ sender: Any) {
  }
  
  @IBAction func randomBtnAction(_ sender: Any) {
  }
}
