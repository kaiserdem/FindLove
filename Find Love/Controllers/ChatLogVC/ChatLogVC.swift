//
//  ChatLogVC.swift
//  Find Love
//
//  Created by Kaiserdem on 27.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class ChatLogVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageZomable {
  
  
  var user: User? {
    didSet {
      self.nameLabel.text = user?.name

      observeMessages()
    }
  }
  
  var messages = [Message]() // масив всех сообщений
  var conteinerViewBottonAnchor: NSLayoutConstraint?

  lazy var inputTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Ведите сообщение..."
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self // подписали делегат
    return textField
  }()
  
  lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = NSTextAlignment.center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var conteinerView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.9030912519, green: 0.9030912519, blue: 0.9030912519, alpha: 1)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var inputConteinerView: UIView = {
    let conteinerView = UIView()
    conteinerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
    conteinerView.backgroundColor = .white
    
    let uploadImageView = UIImageView(image: #imageLiteral(resourceName: "picture.png"))
    uploadImageView.isUserInteractionEnabled = true
    uploadImageView.translatesAutoresizingMaskIntoConstraints = false
    uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
    conteinerView.addSubview(uploadImageView)
    
    uploadImageView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 8).isActive = true
    uploadImageView.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
    uploadImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
    uploadImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    let sendButton = UIButton(type: .system)
    sendButton.setTitle("Отправить", for: .normal)
    //sendButton.setImage(UIImage(named: "back"), for: .normal)
    sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    sendButton.setTitleColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), for: .normal)
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    conteinerView.addSubview(sendButton)
    
    sendButton.rightAnchor.constraint(equalTo: conteinerView.rightAnchor, constant: -10).isActive = true
    sendButton.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
    sendButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
    sendButton.heightAnchor.constraint(equalTo: conteinerView.heightAnchor).isActive = true
    
    conteinerView.addSubview(inputTextField)
    
    inputTextField.leadingAnchor.constraint(equalTo: uploadImageView.trailingAnchor, constant: 8).isActive = true
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
  
//  override var prefersStatusBarHidden: Bool {
//    return true
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.contentInset = UIEdgeInsets.init(top: 78, left: 0, bottom: 5, right: 0)
    collectionView?.alwaysBounceVertical = true
    collectionView?.backgroundColor = UIColor.white
    collectionView?.keyboardDismissMode = .interactive
    collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)

    setupInputComponents()
    setupKeyboardObservise()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self) // убрать обсервер
  }
  
  // поменять констрейнты при смене ориентации
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView?.collectionViewLayout.invalidateLayout()
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

//    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }


  @objc func handleKeyboardDidShow() {
    
    if messages.count > 0 {
      let indexPath = IndexPath(item: self.messages.count-1, section: 0) // последнее
      //проскролить
      self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
    }
  }
//
//  @objc func handleKeyboardWillHide(notification: NSNotification) {
//    conteinerViewBottonAnchor?.constant = 0
//
//    let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
//
//    UIView.animate(withDuration: keyboardDuration) {
//      self.view.layoutIfNeeded()
//    }
//  }
  
  func setupInputComponents() { // компоненты контроллера
    
    let topConteinerView = UIView()
    topConteinerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)// #colorLiteral(red: 0.9030912519, green: 0.9030912519, blue: 0.9030912519, alpha: 1)
    topConteinerView.clipsToBounds = true
    topConteinerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(topConteinerView)
    
    topConteinerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    topConteinerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    topConteinerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    topConteinerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    
    let backButton = UIButton(type: .system)
    backButton.setTitle("Назад", for: .normal)
    backButton.setTitleColor(.black, for: .normal)
    backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    backButton.translatesAutoresizingMaskIntoConstraints = false
    backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    topConteinerView.addSubview(backButton)
    
    backButton.leftAnchor.constraint(equalTo: topConteinerView.leftAnchor, constant: 10).isActive = true
    backButton.centerYAnchor.constraint(equalTo: topConteinerView.centerYAnchor, constant: 15).isActive = true
    backButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
    backButton.heightAnchor.constraint(equalTo: topConteinerView.heightAnchor).isActive = true

    topConteinerView.addSubview(nameLabel)
    
    nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    nameLabel.centerYAnchor.constraint(equalTo: topConteinerView.centerYAnchor, constant: 15).isActive = true
    nameLabel.centerXAnchor.constraint(equalTo: topConteinerView.centerXAnchor).isActive = true
  }
  
  func observeMessages() {
    
    guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else { return }
    
    let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
    userMessagesRef.observe(.childAdded, with: { (snapshot) in
      
      let messageId = snapshot.key
      let messageRef = Database.database().reference().child("messages").child(messageId)
      
      messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
        guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
        
        let message = Message(dictionary: dictionary)
              
          self.messages.append(message)
          
          DispatchQueue.main.async {
            self.collectionView?.reloadData()
            let indexPath = IndexPath(item: self.messages.count-1, section: 0) // последнее
            //проскролить
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
          }
      }, withCancel: nil)
    }, withCancel: nil)
  }
  
  // принимает текст возвращает размер
  private func estimateFrameForText(_ text: String) -> CGRect {
    
    let size = CGSize(width: 200, height: 1000)
    
    // текст прислоняеться к левому краю и использует пренос строки
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }
  
  private func setupCell(_ cell: ChatMessageCell, message: Message) {
    
    if let profileImageUrl = self.user?.profileImageUrl {
      cell.profileImageView.loadImageUsingCachWithUrlString(profileImageUrl)
    }
    
    if let messageImageUrl = message.imageUrl {
      cell.messageImageView.loadImageUsingCachWithUrlString(messageImageUrl)
      cell.messageImageView.isHidden = false
      cell.bubbleView.backgroundColor = .clear
    } else {
      cell.messageImageView.isHidden = true
    }
    
    if message.fromId == Auth.auth().currentUser?.uid { // свои сообщения
      cell.bubbleView.backgroundColor = ChatMessageCell.blueColor 
      cell.textView.textColor = .white
      cell.profileImageView.isHidden = true
      cell.buubleViewRightAnchor?.isActive = true
      cell.buubleViewLeftAnchor?.isActive = false
    } else {
      cell.bubbleView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) // не свои серый
      cell.textView.textColor = .black
      cell.profileImageView.isHidden = false
      
      cell.buubleViewRightAnchor?.isActive = false
      cell.buubleViewLeftAnchor?.isActive = true
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    var selectedImageFromPicker: UIImage?
    if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      selectedImageFromPicker = editingImage
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      selectedImageFromPicker = originalImage
    }
    if let selectedImage = selectedImageFromPicker {
      uploadToFirebaseStorageUsingImage(selectedImage)
    }
    
    dismiss(animated: true, completion: nil) // выйти с контроллера
  }
  
  private func uploadToFirebaseStorageUsingImage(_ image: UIImage) {

    let imageName = UUID().uuidString
    
    // создали папку в базе
    let ref = Storage.storage().reference().child("message_images").child(imageName)
    if let uploadData = image.jpegData(compressionQuality: 0.75) {
      ref.putData(uploadData, metadata: nil) { (metadata, error) in
        if error != nil {
          print(error?.localizedDescription as Any)
          return
        }
        // сохранили картинку
        ref.downloadURL(completion: { (url, error) in
          if error != nil {
            print(error?.localizedDescription as Any)
            return
          }
          if let imageUrl = url {
            self.sendMessageWithImageUrl(imageUrl.absoluteString, image: image)
          }
        })
      }
    }
  }
  
  private func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
 
    let properties = ["imageUrl": imageUrl,"imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
    //print(properties)
    sendMessagesWithProperties(properties)

  }
  
  private func sendMessagesWithProperties(_ properties: [String: Any]) {
    
    let ref = Database.database().reference().child("messages")
    let childRef = ref.childByAutoId()
    let toId = user!.id!
    let fromId = Auth.auth().currentUser!.uid
    let timestamp = Int(Date().timeIntervalSince1970)
    
    var values = [ "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
    
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
  
  func performZoomInForImageView(_ imageView: UIImageView) {
    print(1)
  }
  
  @objc func handleUploadTap() {
    
    let imagePickerController = UIImagePickerController()
  
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    
    present(imagePickerController, animated: true, completion: nil)
  }
  
  @objc func handleBack() {
    let controll = MessagesVC.init(nibName: "MessagesVC", bundle: nil)
    self.navigationController?.pushViewController(controll, animated: true)
  }
  
  
  @objc func handleSend() { // отправляем сообщение
    let properties = ["text": inputTextField.text!] as [String : Any]
    sendMessagesWithProperties(properties)
  }
  
   // текстовое поле возврвщвет
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    handleSend()
    return true
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
    
    cell.deledate = self
    
    let message = messages[indexPath.row]
    cell.textView.text = message.text
    
    setupCell(cell, message: message)
    
    if let text = message.text {
     cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 35
      cell.textView.isHidden = false
    } else if message.imageUrl != nil {
      cell.bubbleWidthAnchor?.constant = 200
      cell.textView.isHidden = true
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    var height: CGFloat = 80
    let message = messages[indexPath.row]
    //print(messages)
    
    if let text = message.text {
      height = estimateFrameForText(text).height + 20
    } else if let imageWidht = message.imageWidth, let imageHight = message.imageHight {
      // сделали размер пропорционально
      height = CGFloat(imageHight / imageWidht * 200)
    }
    return CGSize(width: view.frame.width, height: height)
  }
}
