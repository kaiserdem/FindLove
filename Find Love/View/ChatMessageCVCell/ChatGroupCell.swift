//
//  ChatGroupCell.swift
//  Find Love
//
//  Created by Kaiserdem on 23.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import AVFoundation

class ChatGroupCell: UICollectionViewCell {
  
  var message: Message?
  var deledate: ImageZomable?
  weak var delegate: ProtocolChatGroupDelegate?
  
  static let blueColor = #colorLiteral(red: 0.08570486702, green: 0.2354284908, blue: 0.3383600027, alpha: 1)
  static let grayColor = #colorLiteral(red: 0.7610357215, green: 0.7610357215, blue: 0.7610357215, alpha: 1)
  
  var playerLayer: AVPlayerLayer? //  слой видео
  var player: AVPlayer?
  
  weak var shapeLayer: CAShapeLayer?
  
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
  
  var backImageView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 1, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
    view.layer.cornerRadius = 24
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var backInputView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    view.layer.cornerRadius = 22
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var downBlackView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    view.layer.cornerRadius = 10
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var crownBtn: UIButton = {
    let btn = UIButton(type: .system)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.tintColor = .white
    btn.layer.cornerRadius = 8
    btn.setImage(UIImage(named: "crown")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    btn.imageView?.tintColor = .white
    btn.backgroundColor = #colorLiteral(red: 1, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
    btn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    return btn
  }()
  
  lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "user.png")
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 20
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_ :))))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var messageImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 10
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap(_ : ))))
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
    
    drawLineCrown()
    
    addSubview(backImageView)
    backImageView.addSubview(backInputView)
    backInputView.addSubview(profileImageView)
    addSubview(downBlackView)
    downBlackView.addSubview(crownBtn)
    bringSubviewToFront(downBlackView)
    
    addSubview(bubbleView)
    addSubview(textView)
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
    
    
    backImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2).isActive = true
    backImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
    backImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
    backImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    
    backInputView.centerXAnchor.constraint(equalTo: backImageView.centerXAnchor).isActive = true
    backInputView.centerYAnchor.constraint(equalTo: backImageView.centerYAnchor).isActive = true
    backInputView.widthAnchor.constraint(equalToConstant: 44).isActive = true
    backInputView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    profileImageView.centerXAnchor.constraint(equalTo: backInputView.centerXAnchor).isActive = true
    profileImageView.centerYAnchor.constraint(equalTo: backInputView.centerYAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    downBlackView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
    downBlackView.centerYAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 2).isActive = true
    downBlackView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    downBlackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    crownBtn.centerXAnchor.constraint(equalTo: downBlackView.centerXAnchor).isActive = true
    crownBtn.centerYAnchor.constraint(equalTo: downBlackView.centerYAnchor).isActive = true
    crownBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
    crownBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
    
    
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
  
  private func drawLineCrown() {
    
    self.shapeLayer?.removeFromSuperlayer()
    
    let pathRight = UIBezierPath()
    pathRight.move(to: CGPoint(x: -4, y: 6.2))
    pathRight.addLine(to: CGPoint(x: 2, y: 8))
    
    let pathLeft = UIBezierPath()
    pathLeft.move(to: CGPoint(x: 23, y: 5.3))
    pathLeft.addLine(to: CGPoint(x: 15, y: 7.7))
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0.5019607843, blue: 0.1215686275, alpha: 1).cgColor
    shapeLayer.lineWidth = 2
    shapeLayer.path = pathRight.cgPath
    crownBtn.layer.addSublayer(shapeLayer)
    
    let shapeLayer2 = CAShapeLayer()
    shapeLayer2.strokeColor = #colorLiteral(red: 1, green: 0.5019607843, blue: 0.1215686275, alpha: 1).cgColor
    shapeLayer2.lineWidth = 2
    shapeLayer2.path = pathLeft.cgPath
    crownBtn.layer.addSublayer(shapeLayer2)
    
    self.shapeLayer = shapeLayer
    self.shapeLayer = shapeLayer2
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
  
  @objc func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
    delegate?.imageViewTapped(cell: self)
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
