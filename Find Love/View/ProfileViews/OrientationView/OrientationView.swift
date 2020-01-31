//
//  OrientationView.swift
//  Find Love
//
//  Created by Kaiserdem on 29.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class OrientationView: UIView, UIPickerViewDelegate , UIPickerViewDataSource {
  
  @IBOutlet var orientationView: UIView!
  
  @IBOutlet weak var pickerView: UIPickerView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var orientationSeparator: UIView!
  @IBOutlet weak var orientationLabel: UILabel!
  @IBOutlet weak var orientationBtn: UIButton!
  @IBOutlet weak var saveBtn: UIButton!
  @IBOutlet weak var closeBtn: UIButton!
  @IBOutlet weak var backView: UIView!
  
  var genderArray =  ["Парни", "Девушки", "Девушки и парни"]
  var beforeOrientation = ""
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    setupBtnSettings()
    pickerView.isHidden = true
    pickerView.delegate = self
    pickerView.dataSource = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("OrientationView", owner: self, options: nil)
    orientationView.fixInView(self)
    orientationView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
    backView.layer.borderWidth = 0.5
    
    saveBtn.isEnabled = false
    saveBtn.setTitleColor(.gray, for: .normal)
    
    let opacity:CGFloat = 0.3
    let borderColor = UIColor.white
    backView.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
  }
  
  @IBAction func saveBtnAction(_ sender: Any) {
    guard let orientationTextValue = orientationBtn.titleLabel?.text else { // если пустые, принт, выходим
      print("Error: field is empty")
      return
    }
    
    let ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
    
    print(beforeOrientation)
    if beforeOrientation != orientationTextValue {
      let orientationStr = orientationValidator(string: orientationTextValue)
      let valuesGender = ["orientation": orientationStr] as [String : Any]
      ref.updateChildValues(valuesGender)
    } else {
      saveBtn.isEnabled = false
      saveBtn.setTitleColor(.gray, for: .normal)
    }
    
    removeFromSuperview()
  }
  
  private func orientationValidator(string: String) -> String {
    if string == "Девушки" {
      return "1"
    } else if string == "Парни" {
      return "2"
    } else {
      return "3"
    }
  }
  
  @IBAction func orientationBtnAction(_ sender: Any) {
    pickerView.isHidden = false
    orientationLabel.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    orientationSeparator.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
  }
  
  @IBAction func closeBtnAction(_ sender: Any) {
    self.removeFromSuperview()
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return genderArray.count
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    orientationBtn.setTitle(genderArray[row], for: .normal)
    orientationLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    orientationSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    pickerView.isHidden = true
    
    saveBtn.isEnabled = true
    saveBtn.setTitleColor(.white, for: .normal)
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return genderArray[row]
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
}
