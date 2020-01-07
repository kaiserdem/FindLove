//
//  ExtensionUIView.swift
//  Find Love
//
//  Created by Kaiserdem on 06.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  @discardableResult
  func applyGradient(colours: [UIColor]) -> CAGradientLayer {
    return self.applyGradient(colours: colours, locations: nil)
  }
  
  @discardableResult
  func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = self.bounds
    gradient.colors = colours.map { $0.cgColor }
    gradient.locations = locations
    self.layer.insertSublayer(gradient, at: 2)
    return gradient
  }
}

extension UIView {
  
  func addShadowView(width:CGFloat=0.2, height:CGFloat=0.2, Opacidade:Float = 0.7, maskToBounds:Bool=false, radius:CGFloat = 0.5){
    self.layer.shadowColor = UIColor.blue.cgColor
    self.layer.shadowOffset = CGSize(width: width, height: height)
    self.layer.shadowRadius = radius
    self.layer.shadowOpacity = Opacidade
    self.layer.masksToBounds = maskToBounds
  }
  
}

extension UIView {
  
  func pulsate() {
    
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.3
    pulse.fromValue = 0.95
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = 2
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    
    layer.add(pulse, forKey: "pulse")
  }
  
  func flash() {
    
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 0.5
    flash.fromValue = 1
    flash.toValue = 0.1
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    flash.repeatCount = 3
    
    layer.add(flash, forKey: nil)
  }
  
  
  func shake() {
    
    let shake = CABasicAnimation(keyPath: "position")
    shake.duration = 0.1
    shake.repeatCount = 6
    shake.autoreverses = true
    
    let fromPoint = CGPoint(x: center.x - 5, y: center.y)
    let fromValue = NSValue(cgPoint: fromPoint)
    
    let toPoint = CGPoint(x: center.x + 5, y: center.y)
    let toValue = NSValue(cgPoint: toPoint)
    
    shake.fromValue = fromValue
    shake.toValue = toValue
    
    layer.add(shake, forKey: "position")
  }
}

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
  case topRightBottomLeft
  case topLeftBottomRight
  case horizontal
  case vertical
  
  var startPoint : CGPoint {
    return points.startPoint
  }
  
  var endPoint : CGPoint {
    return points.endPoint
  }
  
  var points : GradientPoints {
    switch self {
    case .topRightBottomLeft:
      return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
    case .topLeftBottomRight:
      return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
    case .horizontal:
      return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
    case .vertical:
      return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
    }
  }
}

extension UIView {
  
  func applyGradient2(with colours: [UIColor], locations: [NSNumber]? = nil) {
    let gradient = CAGradientLayer()
    gradient.frame = self.bounds
    gradient.colors = colours.map { $0.cgColor }
    gradient.locations = locations
    self.layer.insertSublayer(gradient, at: 0)
  }
  
  func applyGradient2(with colours: [UIColor], gradient orientation: GradientOrientation) {
    let gradient = CAGradientLayer()
    gradient.frame = self.bounds
    gradient.colors = colours.map { $0.cgColor }
    gradient.startPoint = orientation.startPoint
    gradient.endPoint = orientation.endPoint
    self.layer.insertSublayer(gradient, at: 0)
  }
}

extension UIView { // for xib
  
  func fixInView(_ container: UIView!) -> Void {
    self.translatesAutoresizingMaskIntoConstraints = false;
    self.frame = container.frame;
    container.addSubview(self);
    NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
  }
}


//extension UIView {
//  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//    let mask = CAShapeLayer()
//    mask.path = path.cgPath
//    layer.mask = mask
//  }
//}

extension UIView{
  func blink() {
    self.alpha = 0.2
    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: {self.alpha = 1.0}, completion: nil)
  }
}

extension UIView {
  
  func addShadow() {
    self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0.0
    self.layer.masksToBounds = false
  }
}
