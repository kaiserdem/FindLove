//
//  ChatCell.swift
//  Find Love
//
//  Created by Kaiserdem on 23.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import AVFoundation

class ChatCell: UICollectionViewCell {
  
  var message: Message?
  
  static let blueColor = #colorLiteral(red: 0.08570486702, green: 0.2354284908, blue: 0.3383600027, alpha: 1)
  static let grayColor = #colorLiteral(red: 0.7610357215, green: 0.7610357215, blue: 0.7610357215, alpha: 1)
  
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
    view.layer.cornerRadius = 10
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
    return imageView
  }()
  
  var nameLabel: UILabel = {
    let label = UILabel()
    label.text = "User Name"
    label.textAlignment = NSTextAlignment.left
    label.textColor = .red
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var timeLabel: UILabel = {
    let label = UILabel()
    label.text = "Yesterday 20:30"
    label.textAlignment = NSTextAlignment.left
    label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    label.font = UIFont.systemFont(ofSize: 11)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()


  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(bubbleView)
    addSubview(textView)
    addSubview(profileImageView)
    addSubview(timeLabel)
    bubbleView.addSubview(nameLabel)
    bubbleView.addSubview(messageImageView)
    
    messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
    messageImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
    messageImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true
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
    profileImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    
    buubleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
    buubleViewRightAnchor!.isActive = true
    
    buubleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
    buubleViewLeftAnchor?.isActive = false
    
    
    bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
    bubbleWidthAnchor?.isActive = true
    bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
    
    textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
    textView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true
    textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
    textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    
    nameLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
    nameLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8).isActive = true

    
    timeLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -2).isActive = true
    timeLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10).isActive = true
    timeLabel.heightAnchor.constraint(equalToConstant: 23).isActive = true
    timeLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
    
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
  
}
