//
//  PostVC.swift
//  Find Love
//
//  Created by Kaiserdem on 04.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices
import FirebaseDatabase

class NewFeedPostCVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
  var user: User? 
  var posts = [Post]()
  
  var conteinerViewBottonAnchor: NSLayoutConstraint?
  
  lazy var inputTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Ведите содержание поста..."
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self // подписали делегат
    return textField
  }()

  lazy var conteinerView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9030912519, green: 0.9030912519, blue: 0.9030912519, alpha: 1)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = NSTextAlignment.center
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 18)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Новый пост"
    return label
  }()
  
  lazy var inputConteinerView: UIView = {
    let conteinerView = UIView()
    conteinerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
    conteinerView.backgroundColor = .white
    
//    let uploadImageView = UIImageView(image: #imageLiteral(resourceName: "picture.png"))
//    uploadImageView.tintColor = .gray
//    uploadImageView.isHidden = true
//    uploadImageView.isUserInteractionEnabled = true
//    uploadImageView.translatesAutoresizingMaskIntoConstraints = false
//    //uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
//    conteinerView.addSubview(uploadImageView)
//
//    uploadImageView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 8).isActive = true
//    uploadImageView.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
//    uploadImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
//    uploadImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    
    let sendButton = UIButton(type: .system)

    let image = UIImage(named: "send")
    sendButton.setImage(image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    sendButton.imageView?.contentMode = .scaleAspectFit
    sendButton.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    conteinerView.addSubview(sendButton)
    
    sendButton.rightAnchor.constraint(equalTo: conteinerView.rightAnchor, constant: -10).isActive = true
    sendButton.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
    sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    sendButton.heightAnchor.constraint(equalTo: conteinerView.heightAnchor).isActive = true
    
    conteinerView.addSubview(inputTextField)
    
    inputTextField.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 8).isActive = true
    inputTextField.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
    inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
    inputTextField.heightAnchor.constraint(equalTo: conteinerView.heightAnchor).isActive = true
    
    let separatorLineView = UIView()
    separatorLineView.backgroundColor = UIColor.black
    separatorLineView.translatesAutoresizingMaskIntoConstraints = false
    conteinerView.addSubview(separatorLineView)
    
    separatorLineView.leftAnchor.constraint(equalTo: conteinerView.leftAnchor).isActive = true
    separatorLineView.topAnchor.constraint(equalTo: conteinerView.topAnchor).isActive = true
    separatorLineView.widthAnchor.constraint(equalTo: conteinerView.widthAnchor).isActive = true
    separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    return conteinerView
  }()
  
  let cellId = "cellId"
  
  

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.contentInset = UIEdgeInsets.init(top: 78, left: 0, bottom: 5, right: 0)
    collectionView?.alwaysBounceVertical = true
    collectionView?.backgroundColor = #colorLiteral(red: 0.1124108919, green: 0.1124108919, blue: 0.1124108919, alpha: 1)
    collectionView?.keyboardDismissMode = .interactive
    
    setupInputComponents()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self) // убрать обсервер
  }
  
  override var inputAccessoryView: UIView? { // вю короторе отвечает за клавиатуру
    get {
      return inputConteinerView
    }
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  

  func setupInputComponents() { // компоненты контроллера
    
    let topConteinerView = UIView()
    topConteinerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    topConteinerView.clipsToBounds = true
    topConteinerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(topConteinerView)
    
    topConteinerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    topConteinerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    topConteinerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    topConteinerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    let backButton = UIButton(type: .system)
    let image = UIImage(named: "back")
    backButton.setImage(image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    backButton.imageView?.contentMode = .scaleAspectFit
    backButton.tintColor = .white
    backButton.setTitleColor(.white, for: .normal)
    backButton.imageEdgeInsets = UIEdgeInsets(top: 7.0, left: 0.0, bottom: 7.0, right: 0.0)
    backButton.translatesAutoresizingMaskIntoConstraints = false
    backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    topConteinerView.addSubview(backButton)
    
    backButton.leftAnchor.constraint(equalTo: topConteinerView.leftAnchor, constant: 10).isActive = true
    backButton.centerYAnchor.constraint(equalTo: topConteinerView.centerYAnchor, constant: 0).isActive = true
    backButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    topConteinerView.addSubview(nameLabel)

    nameLabel.heightAnchor.constraint(equalTo: topConteinerView.heightAnchor).isActive = true
    nameLabel.centerYAnchor.constraint(equalTo: topConteinerView.centerYAnchor, constant: 0).isActive = true
    nameLabel.centerXAnchor.constraint(equalTo: topConteinerView.centerXAnchor).isActive = true
  }

  private func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
    
    let properties = ["imageUrl": imageUrl,"imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
    
    sendMessagesWithProperties(properties)
    
  }
  
  private func sendMessagesWithProperties(_ properties: [String: Any]) {
    
    let ref = Database.database().reference().child("posts")
    let childRef = ref.childByAutoId()
    let fromId = Auth.auth().currentUser!.uid
    let timestamp = Int(Date().timeIntervalSince1970)
    
    
    var values = ["postId": childRef.key!, "fromId": fromId, "timestamp": timestamp] as [String : Any]
    
    properties.forEach { (key: String, value: Any) in // метод принимает данные
      values[key] = value
    }
    
    ref.child(fromId).updateChildValues(values) { (error, ref) in
      if error != nil {
        print(error!)
        return
      }
    }
    self.inputTextField.text = nil
    
    dismiss(animated: true, completion: nil)
  }
 
  
  @objc func handleBack() {
    dismiss(animated: true, completion: nil)
  }
  
  
  @objc func handleSend() { // отправляем сообщение
    
    if (inputTextField.text?.isEmpty)! {
      let viewCustomAlertWarning = CustomAlertWarning(frame: self.view.frame)
      viewCustomAlertWarning.textTextView.text = "Пост не может быть пустым"
      viewCustomAlertWarning.backViewConstraintCenterY.constant = -70
      view.addSubview(viewCustomAlertWarning)
      return
      
    } else if (inputTextField.text?.count)! > 200 {
      let viewCustomAlertWarning = CustomAlertWarning(frame: self.view.frame)
      viewCustomAlertWarning.label.text = "Ошибка"
      viewCustomAlertWarning.textViewConstraintHeight.constant = 95
      viewCustomAlertWarning.textTextView.text = "Превышено максимально допустимое количество символов. Текст не должен привышать 200 символов."
      viewCustomAlertWarning.backViewConstraintCenterY.constant = -85
      view.addSubview(viewCustomAlertWarning)
      return
    }
    
    let properties = ["text": inputTextField.text!] as [String : Any]
    sendMessagesWithProperties(properties)
  }
  
  // текстовое поле возврвщвет
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    handleSend()
    return true
  }
 
}
