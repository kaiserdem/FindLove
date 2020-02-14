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
  
  var beforeName = ""
  var beforeAge = ""
  var beforeGender = ""
  
  
  var genderArray = ["Мужской","Женский",]
  var ageArray = [Int]()
  var pickerValue = 1
  
  var user: User?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()

    registerNotificationObservers()
    setupBtnSettings()
    
    for i in 16 ... 100 {
      ageArray.append(i)
    }
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    beforeName = nameTextField.text!
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func registerNotificationObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  
  @objc func keyboardWillAppear(_ notification: Notification) {
    
    saveBtn.isEnabled = true
    saveBtn.setTitleColor(.white, for: .normal)
    
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
    
    saveBtn.isEnabled = false
    saveBtn.setTitleColor(.gray, for: .normal)
    
    nameTextField.attributedPlaceholder = NSAttributedString(string: "Имя", attributes:[NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
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
    
    guard let name = nameTextField.text , let age = ageBtn.titleLabel?.text, let gender = genderBtn.titleLabel?.text else { // если пустые, принт, выходим
      print("Error: field is empty")
      return
    }
    if nameTextField.text?.isEmpty == true {
      let view = CustomAlertWarning(frame: self.infornatioView.frame)
      infornatioView.addSubview(view)
      return
    }
    
    let ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
    
    if beforeName != name {
      let valuesName = ["name": name] as [String : Any]
      ref.updateChildValues(valuesName)
      
    }
    
    if beforeGender != gender {
      let genderStr = genderValidatorToIndex(string: gender)
      let valuesGender = ["gender": genderStr] as [String : Any]
      ref.updateChildValues(valuesGender)
    }
    
    if beforeAge != age {
      let ageInt = Int(age)
      let valuesName = ["age": ageInt] as [String : Any]
      ref.updateChildValues(valuesName)
    }
    removeFromSuperview()
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
      ageBtn.setTitle(String(describing:ageArray[row]), for: .normal)
      ageLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      ageSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    } else {
      genderBtn.setTitle(String(describing:genderArray[row]), for: .normal)
      genderLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      genderSeparator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    pickerView.isHidden = true
    saveBtn.isEnabled = true
    saveBtn.setTitleColor(.white, for: .normal)
    reloadInputViews()
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
    
    let image = UIImage(named: "down")
    ageBtn.tintColor = .white
    let buttonView = UIImageView(image: image)
    buttonView.contentMode = UIView.ContentMode.scaleAspectFit
    buttonView.layer.masksToBounds = true
    ageBtn.addSubview(buttonView)
    
    buttonView.rightAnchor.constraint(equalTo: ageBtn.rightAnchor).isActive = true
    
    buttonView.widthAnchor.constraint(equalToConstant: 15).isActive = true
    buttonView.heightAnchor.constraint(equalToConstant: 15).isActive = true
    
    buttonView.bottomAnchor.constraint(equalTo: ageBtn.bottomAnchor, constant: -5.0).isActive = true
    buttonView.translatesAutoresizingMaskIntoConstraints = false

    ageBtn.tintColor = .white

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
