//
//  UserProfileInfoView.swift
//  Find Love
//
//  Created by Kaiserdem on 02.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

//
//  OpenFeedPost.swift
//  Find Love
//
//  Created by Kaiserdem on 16.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class UserProfileInfoView: UIView {
  
  @IBOutlet weak var backView: UIView!
  @IBOutlet var userProfileInfoView: UIView!
  @IBOutlet weak var aboutSelfTextViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var statusTextViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var ageLabelHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var orientationLabelHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var genderLabelHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var aboutSelfTextView: UITextView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var statusTextView: UITextView!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var orientationLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var aboutSelfSeparatorView: UIView!
  @IBOutlet weak var orientationSeparatorView: UIView!
  @IBOutlet weak var statusSeparatorView: UIView!
  @IBOutlet weak var ageSeparatorView: UIView!
  @IBOutlet weak var genderSeparatorView: UIView!

  var startFrame: CGRect?
  var blackBackgroundView: UIView?
  var startingImageView: UIImageView?
  
  var user: User?
  weak var feedVC: FeedVC?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    
    userProfileInfoView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.9)
    backView.layer.borderWidth = 0.5
    
    let opacity:CGFloat = 0.3
    let borderColor = UIColor.white
    backView.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
    
    profileImageView.layer.cornerRadius = 10
    profileImageView.layoutIfNeeded()
    statusTextView.layer.cornerRadius = 8
    aboutSelfTextView.layer.cornerRadius = 8
    ageLabel.layer.cornerRadius = 8
    ageLabel.layoutIfNeeded()
    
    profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelZoomTap)))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("UserProfileInfoView", owner: self, options: nil)
    userProfileInfoView.fixInView(self)
    
  }
  
  @objc func handelZoomTap(_ gestureRecognizer: UITapGestureRecognizer) {
    if let imageView = gestureRecognizer.view as? UIImageView {
      performZoomInForImageView(imageView)
    }
  }
  
  func performZoomInForImageView(_ imageView: UIImageView) {
    startingImageView = imageView
    startingImageView?.isHidden = true
    
    var csdcsc = 
    
    // конвертирует прямоуголтник
    startFrame = imageView.superview?.convert(imageView.frame, to: nil)
    
    let zoomingImageView = UIImageView(frame: startFrame!) // получили картинку по фрейму
    zoomingImageView.image = imageView.image
    zoomingImageView.contentMode = .scaleAspectFit
    zoomingImageView.isUserInteractionEnabled = true
    zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut(_:))))
    
    if let keyWindow = UIApplication.shared.keyWindow {
      blackBackgroundView = UIView(frame: keyWindow.frame)
      blackBackgroundView?.backgroundColor = .black
      blackBackgroundView?.alpha = 0
      keyWindow.addSubview(blackBackgroundView!)
      
      keyWindow.addSubview(zoomingImageView)
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.blackBackgroundView?.alpha = 1
        
        let height = self.startFrame!.height / self.startFrame!.width * keyWindow.frame.width
        
        zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
        zoomingImageView.center = keyWindow.center
        
      }, completion: nil)
    }
  }
  
  @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
    if let zoomOutImageView = tapGesture.view as? UIImageView {
      DispatchQueue.main.async {
        zoomOutImageView.layer.cornerRadius = 52
        zoomOutImageView.clipsToBounds = true
      }
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        zoomOutImageView.frame = self.startFrame!
        self.blackBackgroundView?.alpha = 0
      }) { [weak self] (complete) in
        zoomOutImageView.removeFromSuperview()
        self?.startingImageView?.isHidden = false
      }
    }
  }
  
  @IBAction func closeButtonAction(_ sender: Any) {
    self.removeFromSuperview()
  }
  
}
