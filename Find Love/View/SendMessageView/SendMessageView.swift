//
//  SendMessageView.swift
//  Find Love
//
//  Created by Kaiserdem on 17.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class SendMessageView: UIView {
  
  @IBOutlet var sendMessageView: UIView!
  @IBOutlet weak var checkBackView: UIView!
  
  weak var shapeLayer: CAShapeLayer?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    drawTickAmimate()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      self.removeFromSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("SendMessageView", owner: self, options: nil)
    sendMessageView.fixInView(self)
    sendMessageView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
  }
  
  func drawTickAmimate() {
    self.shapeLayer?.removeFromSuperlayer()
    
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 52, y: 67))
    path.addLine(to: CGPoint(x: 67, y: 83))
    path.addLine(to: CGPoint(x: 97, y: 48))
    path.lineCapStyle = .round
    path.lineJoinStyle = .round
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
    shapeLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    shapeLayer.lineWidth = 4
    shapeLayer.path = path.cgPath
    shapeLayer.lineCap = CAShapeLayerLineCap.round
    
    checkBackView.layer.addSublayer(shapeLayer)
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.duration = 1
    shapeLayer.add(animation, forKey: "MyAnimation")
    
    self.shapeLayer = shapeLayer
  }
}
