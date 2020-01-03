//
//  ChatMessageCell.swift
//  Find Love
//
//  Created by Kaiserdem on 28.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import AVFoundation

protocol ImageZomable {
  func performZoomInForImageView(_ imageView: UIImageView)
}

class ChatMessageCell: UICollectionViewCell {
  
  var deledate: ImageZomable?
  var message: Message?
  
  static let blueColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
  static let grayColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
  
  var playerLayer: AVPlayerLayer? //  слой видео
  var player: AVPlayer?
  
  var bubbleWidthAnchor: NSLayoutConstraint?
  var buubleViewRightAnchor: NSLayoutConstraint?
  var buubleViewLeftAnchor: NSLayoutConstraint?
  
  let textView: UITextView = {
    let tv = UITextView()
    tv.isEditable = false
    tv.font = UIFont.systemFont(ofSize: 16)
    tv.backgroundColor = .clear
    tv.translatesAutoresizingMaskIntoConstraints = false
    return tv
  }()
  
  var activityIndicatorView: UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .whiteLarge)
    aiv.translatesAutoresizingMaskIntoConstraints = false
    aiv.hidesWhenStopped = true
    return aiv
  }()
  
  lazy var playBtn: UIButton = {
    let btn = UIButton(type: .system)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.tintColor = .white
    btn.setImage(#imageLiteral(resourceName: "play-button.png"), for: .normal)
    btn.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
    return btn
  }()
  
  
  // вю фон для сообщений
  let bubbleView: UIView = {
    let view = UIView()
    view.backgroundColor = blueColor
    view.layer.cornerRadius = 16
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "user.png")
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 16
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var messageImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 16
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap(_ : ))))
    return imageView
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(bubbleView)
    addSubview(textView)
    addSubview(profileImageView)
    bubbleView.addSubview(messageImageView)
    
    messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
    messageImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
    messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
    messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
    
    
    bubbleView.addSubview(playBtn)
    playBtn.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
    playBtn.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
    playBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
    playBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
    
    
    bubbleView.addSubview(activityIndicatorView)
    activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
    activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
    activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    
    profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
    profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    
    buubleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
    buubleViewRightAnchor!.isActive = true
    
    buubleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
    buubleViewLeftAnchor?.isActive = false
    
    
    bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
    bubbleWidthAnchor?.isActive = true
    bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    
    textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
    textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
    textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func handlePlay() {
    
    if let videoUrlString = message?.videoUrl, let url = URL(string: videoUrlString) {
      player = AVPlayer(url: url)
      
      playerLayer = AVPlayerLayer(player: player)
      playerLayer?.frame = bubbleView.bounds
      bubbleView.layer.addSublayer(playerLayer!)
      
      player?.play()
      activityIndicatorView.stopAnimating()
      playBtn.isHidden = true
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    playerLayer?.removeFromSuperlayer()
    player?.pause()
    activityIndicatorView.stopAnimating()
  }
  
  @objc func handleZoomTap(_ gestureRecognizer: UITapGestureRecognizer) {
    
    if message?.videoUrl != nil {
      return
    }
    if let imageView = gestureRecognizer.view as? UIImageView {
      deledate?.performZoomInForImageView(imageView)
    }
  }
  
}
