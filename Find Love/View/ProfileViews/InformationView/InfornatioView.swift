//
//  InfornatioView.swift
//  Find Love
//
//  Created by Kaiserdem on 28.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class InfornatioView: UIView {
  
  @IBOutlet var infornatioView: UIView!
  
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var nameSeparator: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var ageSeparator: UIView!
  @IBOutlet weak var ageBtn: UIButton!
  @IBOutlet weak var ageLabel: UILabel!
  
  @IBOutlet weak var genderSeparator: UIView!
  @IBOutlet weak var genderBtn: UIButton!
  @IBOutlet weak var genderLabel: UILabel!
  
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
    Bundle.main.loadNibNamed("InfornatioView", owner: self, options: nil)
    infornatioView.fixInView(self)
    infornatioView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
  }
  
  private func setupBtnSettings() {
    
    ageBtn.setImage(UIImage(named: "down")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    ageBtn.tintColor = .white
    ageBtn.imageView?.trailingAnchor.constraint(equalTo: ageSeparator.trailingAnchor, constant: 0.0).isActive = true
    ageBtn.imageView?.bottomAnchor.constraint(equalTo: ageBtn.bottomAnchor, constant: -5.0).isActive = true
    ageBtn.imageView?.heightAnchor.constraint(equalToConstant: 15).isActive = true
    ageBtn.imageView?.widthAnchor.constraint(equalToConstant: 15).isActive = true
    
    ageBtn.translatesAutoresizingMaskIntoConstraints = false
    ageBtn.imageView?.translatesAutoresizingMaskIntoConstraints = false

    genderBtn.setImage(UIImage(named: "down")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    genderBtn.tintColor = .white
    genderBtn.imageView?.trailingAnchor.constraint(equalTo: genderSeparator.trailingAnchor, constant: 0.0).isActive = true
    genderBtn.imageView?.bottomAnchor.constraint(equalTo: genderBtn.bottomAnchor, constant: -5.0).isActive = true
    genderBtn.imageView?.heightAnchor.constraint(equalToConstant: 15).isActive = true
    genderBtn.imageView?.widthAnchor.constraint(equalToConstant: 15).isActive = true
    genderBtn.translatesAutoresizingMaskIntoConstraints = false
    genderBtn.imageView?.translatesAutoresizingMaskIntoConstraints = false

  }
  
  
  
  
  
  @IBAction func selectAgeBtnAction(_ sender: Any) {
  }
  
  @IBAction func selectGenderBtnAction(_ sender: Any) {
  }
  
  @IBAction func saveBtnAction(_ sender: Any) {
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    self.removeFromSuperview()
  }
}
