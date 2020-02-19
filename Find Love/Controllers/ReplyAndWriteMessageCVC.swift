//
//  ReplyToFeedPostVC.swift
//  Find Love
//
//  Created by Kaiserdem on 17.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices
import FirebaseDatabase

class ReplyAndWriteMessageCVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var user: User?
  var posts = [Post]()
  var stausMessage = ""
  var responseToText = ""
  var conteinerViewBottonAnchor: NSLayoutConstraint?
  
  lazy var inputTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Ведите сообщение..."
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
    label.text = "Ответ на пост"
    return label
  }()
  
  lazy var postText: UITextView = {
    let textView = UITextView()
    textView.textAlignment = NSTextAlignment.left
    textView.textColor = .white
    textView.isEditable = false
    textView.isSelectable = false
    textView.font = UIFont.systemFont(ofSize: 18)
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.backgroundColor = .clear
    return textView
  }()
  
  lazy var inputConteinerView: UIView = {
    let conteinerView = UIView()
    conteinerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
    conteinerView.backgroundColor = .white

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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.contentInset = UIEdgeInsets.init(top: 78, left: 0, bottom: 5, right: 0)
    collectionView?.alwaysBounceVertical = true
    collectionView?.backgroundColor = #colorLiteral(red: 0.1830653183, green: 0.1830653183, blue: 0.1830653183, alpha: 1)
    collectionView?.keyboardDismissMode = .interactive

    UIApplication.shared.statusBarView?.backgroundColor = .black
    
    setupInputComponents()
    setupKeyboardObservise()
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
  
  func setupKeyboardObservise() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
  }
  
  @objc func handleKeyboardDidShow() {
    if posts.count > 0 {
      let indexPath = IndexPath(item: self.posts.count-1, section: 0) // последнее
      //проскролить
      self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
    }
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
    
    view.addSubview(postText)
    postText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    postText.topAnchor.constraint(equalTo: topConteinerView.bottomAnchor, constant: 20).isActive = true
    postText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    postText.heightAnchor.constraint(equalToConstant: 120).isActive = true
  }

  private func sendMessagesWithProperties(_ properties: [String: Any]) {
    
    let ref = Database.database().reference().child("messages")
    let childRef = ref.childByAutoId()
    
    let toId = user!.id!
    let fromId = Auth.auth().currentUser!.uid
    let timestamp = Int(Date().timeIntervalSince1970)
    
    let responseToText = self.responseToText
    
    var values = [ "toId": toId, "fromId": fromId, "timestamp": timestamp, "responseToText": responseToText, "stausMessage": stausMessage] as [String : Any]
    
    properties.forEach { (key: String, value: Any) in // метод принимает данные
      values[key] = value
    }
    
    childRef.updateChildValues(values) { (error, ref) in
      if error != nil {
        print(error!)
        return
      }
    }
    
    self.inputTextField.text = nil
    
    let refFromTo = Database.database().reference().child("user-messages").child(fromId).child(toId)
    
    let messageId = childRef.key
    let values2 = [messageId: 1] as! [String : Any]
    
    refFromTo.updateChildValues(values2) { (error, ref) in
      if error != nil {
        print(error!)
        return
      }
    }
    
    let refToFrom = Database.database().reference().child("user-messages").child(toId).child(fromId)
    
    let messageId3 = childRef.key
    let values3 = [messageId3: 1] as! [String : Any]
    
    refToFrom.updateChildValues(values3) { (error, ref) in
      if error != nil {
        print(error!)
        return
      }
    }
  }
  
  @objc func handleBack() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func handleSend() { // отправляем сообщение
    if (inputTextField.text?.isEmpty)! {
      let viewCustomAlertWarning = CustomAlertWarning(frame: self.view.frame)
      viewCustomAlertWarning.textTextView.text = "Поле не может быть пустым"
      viewCustomAlertWarning.backViewConstraintCenterY.constant = -70
      view.addSubview(viewCustomAlertWarning)
      return
      
    } else if (inputTextField.text?.count)! > 150 {
      let viewCustomAlertWarning = CustomAlertWarning(frame: self.view.frame)
      viewCustomAlertWarning.label.text = "Ошибка"
      viewCustomAlertWarning.textViewConstraintHeight.constant = 95
      viewCustomAlertWarning.textTextView.text = "Превышено максимально допустимое количество символов. Текст не должен привышать 150 символов."
      viewCustomAlertWarning.backViewConstraintCenterY.constant = -85
      view.addSubview(viewCustomAlertWarning)
      return
    } else if  user!.id! == Auth.auth().currentUser!.uid {
      let viewCustomAlertWarning = CustomAlertWarning(frame: self.view.frame)
      viewCustomAlertWarning.label.text = "Ошибка"
      viewCustomAlertWarning.textViewConstraintHeight.constant = 75
      viewCustomAlertWarning.textTextView.text = "Вы автор этого поста, нельзя отвечать самому себе)"
      viewCustomAlertWarning.backViewConstraintCenterY.constant = -80
      view.addSubview(viewCustomAlertWarning)
      return
    }
    let properties = ["text": inputTextField.text!] as [String : Any]
    sendMessagesWithProperties(properties)
    dismiss(animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    handleSend()
    return true
  }
  
}
