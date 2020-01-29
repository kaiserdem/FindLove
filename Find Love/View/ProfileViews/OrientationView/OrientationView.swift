//
//  OrientationView.swift
//  Find Love
//
//  Created by Kaiserdem on 29.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class OrientationView: UIView {
  
  @IBOutlet var orientationView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var orientationSeparator: UIView!
  @IBOutlet weak var orientationLabel: UILabel!
  @IBOutlet weak var orientationBtn: UIButton!
  @IBOutlet weak var saveBtn: UIButton!
  @IBOutlet weak var closeBtn: UIButton!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    setupBtnSettings()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("OrientationView", owner: self, options: nil)
    orientationView.fixInView(self)
    orientationView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
  }
  private func setupBtnSettings() {
    orientationBtn.setImage(UIImage(named: "down")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    orientationBtn.tintColor = .white
    
    orientationBtn.imageView?.rightAnchor.constraint(equalTo: orientationBtn.rightAnchor, constant: 0.0).isActive = true
    orientationBtn.imageView?.bottomAnchor.constraint(equalTo: orientationBtn.bottomAnchor, constant: -5.0).isActive = true
    orientationBtn.imageView?.heightAnchor.constraint(equalToConstant: 15).isActive = true
    orientationBtn.imageView?.widthAnchor.constraint(equalToConstant: 15).isActive = true
    
    orientationBtn.translatesAutoresizingMaskIntoConstraints = false
    orientationBtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
  }
  @IBAction func saveBtnAction(_ sender: Any) {
  }
  @IBAction func orientationBtnAction(_ sender: Any) {
  }
  @IBAction func closeBtnAction(_ sender: Any) {
    self.removeFromSuperview()
  }
}
