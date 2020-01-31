//
//  InfornatioView.swift
//  Find Love
//
//  Created by Kaiserdem on 28.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class InfornatioView: UIView, UIPickerViewDelegate , UIPickerViewDataSource {
  
  @IBOutlet var infornatioView: UIView!
  @IBOutlet weak var pickerView: UIPickerView!
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
  @IBOutlet weak var backView: UIView!
  
  var genderArray = ["Мужской","Женский",]
  var ageArray = [Int]()
  var pickerValue = 1
  
  var user: User?
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    
    registerNotificationObservers()
    setupBtnSettings()
    
    for i in 0 ... 100 {
      ageArray.append(i)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func registerNotificationObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  @objc func keyboardWillAppear(_ notification: Notification) {
    nameLabel.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    nameSeparator.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    genderLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    genderSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    ageLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    ageSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
  }
  @objc func keyboardWillDisappear(_ notification: Notification) {
    nameLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    nameSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("InfornatioView", owner: self, options: nil)
    infornatioView.fixInView(self)
    infornatioView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
    pickerView.isHidden = true
    pickerView.delegate = self
    pickerView.dataSource = self
    
    let opacity:CGFloat = 0.3
    let borderColor = UIColor.white
    backView.layer.borderWidth = 0.5
    backView.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
  }
  
  @IBAction func selectAgeBtnAction(_ sender: Any) {
    pickerValue = 0
    pickerView.isHidden = false
    pickerView.reloadAllComponents()
    ageLabel.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    ageSeparator.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    genderLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    genderSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    nameLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    nameSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
  }
  
  @IBAction func selectGenderBtnAction(_ sender: Any) {
    pickerValue = 1
    pickerView.isHidden = false
    pickerView.reloadAllComponents()
    genderLabel.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    genderSeparator.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    ageLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    ageSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    nameLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    nameSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
  }
  
  @IBAction func saveBtnAction(_ sender: Any) {
    
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    NotificationCenter.default.removeObserver(self)
    self.removeFromSuperview()
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerValue == 0 {
      return ageArray.count
    } else {
      return genderArray.count
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerValue == 0 {
      ageBtn.titleLabel!.text = String(describing: ageArray[row])
      ageLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      ageSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    } else {
      genderBtn.titleLabel!.text = String(describing: genderArray[row])
      genderLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      genderSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    pickerView.isHidden = true
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    if component == 0 {
      if pickerValue == 0 {
        return String(describing: ageArray[row])
      } else  {
        return String(describing:genderArray[row])
      }
    }
    return ""
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
}
