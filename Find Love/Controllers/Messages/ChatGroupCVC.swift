//
//  ChatWriteMessageVC.swift
//  Find Love
//
//  Created by Kaiserdem on 13.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import AVFoundation
import MobileCoreServices

protocol ProtocolChatGroupDelegate: class {
  func imageViewTapped(cell: ChatGroupCell)
}

class ChatGroupCVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageZomable, ProtocolChatGroupDelegate {
  
  var user: User? {
    didSet {
      self.nameLabel.text = user?.name
      
      observeMessages()
    }
  }
  
  var group: Group? {
    didSet {
      self.nameLabel.text = group?.subject
    }
  }
  
  var messages = [Message]() // масив всех сообщений
  var currentUser = [User]()
  
  var conteinerViewBottonAnchor: NSLayoutConstraint?
  
  let defaults = UserDefaults.standard
  lazy var arrayBlockUsers = defaults.stringArray(forKey: "arrayBlockUsers") ?? [String]()
  
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
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 18)
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
    uploadImageView.tintColor = .gray
    uploadImageView.isUserInteractionEnabled = true
    uploadImageView.translatesAutoresizingMaskIntoConstraints = false
    uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
    conteinerView.addSubview(uploadImageView)
    
    uploadImageView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 8).isActive = true
    uploadImageView.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
    uploadImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
    uploadImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.contentInset = UIEdgeInsets.init(top: 78, left: 0, bottom: 5, right: 0)
    collectionView?.alwaysBounceVertical = true
    collectionView?.backgroundColor = #colorLiteral(red: 0.1830653183, green: 0.1830653183, blue: 0.1830653183, alpha: 1)
    collectionView?.keyboardDismissMode = .interactive
    collectionView?.register(ChatGroupCell.self, forCellWithReuseIdentifier: cellId)
    
    setupInputComponents()
    setupKeyboardObservise()
    fetchUser()
    observeMessages()
    
    UIApplication.shared.statusBarView?.backgroundColor = .black
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    observeChatInvitation()
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
    if messages.count > 0 {
      let indexPath = IndexPath(item: self.messages.count-1, section: 0) // последнее
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
    backButton.imageEdgeInsets = UIEdgeInsets(top: 7.0, left: 0.0, bottom: 7.0, right: 0.0)
    backButton.tintColor = .white
    backButton.setTitleColor(.white, for: .normal)
    backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
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
  
  private func observeChatInvitation() {
    
    arrayBlockUsers = defaults.stringArray(forKey: "arrayBlockUsers") ?? [String]()
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let ref = Database.database().reference().child("user-request").child(uid)
    ref.observe(.childAdded, with: { [weak self] (snapshot) in
      
      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
      
      let request = Request(dictionary: dictionary)
      
      if request.toId == uid {
        if self?.arrayBlockUsers.contains(request.fromUserId!) == false {
          if request.statusRequest == "0" {
            let invitationView = ChatInvitationView(frame: (self?.view.frame)!)
            invitationView.request = request
            invitationView.toGroupTextView.text = request.toGroup
            invitationView.userNameLabel.text = request.fromUser
            invitationView.userImageView.loadImageUsingCache(request.fromImageUrl!)
            invitationView.requestId = snapshot.key
            self?.view.addSubview(invitationView)
          }
        } else {
          ref.child(snapshot.key).removeValue()
        }
      }
      }, withCancel: nil)
  }
  
  private func fetchUser() { // выбрать пользователя
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        let user = User(dictionary: dictionary)
        self?.currentUser.append(user)
      }
    }, withCancel: nil)
  }
  
  // утечка памяти, не работает [weak self]
  private func observeMessages() {
    
    arrayBlockUsers = defaults.stringArray(forKey: "arrayBlockUsers") ?? [String]()
    
    let userMessagesRef = Database.database().reference().child("groups").child(group!.subject!).child("messages")
    
    userMessagesRef.observe(.childAdded, with: {  (snapshot) in
      
      let messageId = snapshot.key
      let messageRef = userMessagesRef.child(messageId)
      
      messageRef.observeSingleEvent(of: .value, with: {  (snapshot) in
        
        guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
        
        let message = Message(dictionary: dictionary)
        message.messadeId = snapshot.key
        self.messages.append(message)
        
        
        DispatchQueue.main.async {
          self.collectionView?.reloadData()
          let indexPath = IndexPath(item: (self.messages.count)-1, section: 0) // последнее
          //проскролить
          self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
        }
      }, withCancel: nil)
    }, withCancel: nil)
  }
  
  private func setupCell(_ cell: ChatGroupCell, message: Message) {
    
    if (self.arrayBlockUsers.contains(message.fromId!)) {
      cell.messageImageView.isHidden = true
      cell.bubbleView.backgroundColor = #colorLiteral(red: 0.2222529795, green: 0.2222529795, blue: 0.2222529795, alpha: 1)
      cell.bubbleWidthAnchor?.constant = 160
      cell.buubleViewRightAnchor?.isActive = false
      cell.buubleViewLeftAnchor?.isActive = true
    } else {
      
      if let profileImageUrl = self.user?.profileImageUrl {
        cell.profileImageView.loadImageUsingCache(profileImageUrl)
      }
      
      if let messageImageUrl = message.imageUrl {
        cell.messageImageView.loadImageUsingCache(messageImageUrl)
        cell.messageImageView.isHidden = false
        cell.bubbleView.backgroundColor = .clear
      } else {
        cell.messageImageView.isHidden = true
      }
      
      if message.fromId == Auth.auth().currentUser?.uid { // свои сообщения
        cell.bubbleView.backgroundColor = ChatGroupCell.blueColor
        cell.textView.textColor = .white
        cell.profileImageView.isHidden = true
        cell.backImageView.isHidden = true
        cell.downBlackView.isHidden = true
        cell.buubleViewRightAnchor?.isActive = true
        cell.buubleViewLeftAnchor?.isActive = false
      } else {
        cell.bubbleView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) // не свои серый
        cell.textView.textColor = .black
        cell.profileImageView.isHidden = false
        cell.backImageView.isHidden = false
        cell.downBlackView.isHidden = false
        cell.buubleViewRightAnchor?.isActive = false
        cell.buubleViewLeftAnchor?.isActive = true
      }
    }
  }
  
  
  func imageViewTapped(cell: ChatGroupCell) {
    
    guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
    
    let message = messages[indexPath.row]
    
    let ref = Database.database().reference().child("users").child(message.fromId!)
    ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        let user = User(dictionary: dictionary)
        user.id = snapshot.key
        
        self?.showAlertMulty(write: true, profile: true, invite: true, complain: true, block: true, cancels: true, choiceWriteAction: {
          self?.showChatLogVCForUser(user)
          
        }, choiceOpenProfile: {
          self?.openProfile(user)
          
        }, choiceInviteChat: {
          self?.chatInvition(user)
          
        }, choiceComplain: {
          
          self?.openComplainVC(user, message: message.text ?? "", messageId: message.messadeId! , fromUserId: message.fromId!)
          return
          
        }, choiceBlockUser: {
          self?.arrayBlockUsers.append(user.id!)
          self?.defaults.set(self?.arrayBlockUsers, forKey: "arrayBlockUsers")
          self?.observeMessages()
        }) {
          return
        }
      }
      }, withCancel: nil)
  }
  
  func openComplainVC(_ user: User?, message: String, messageId: String, fromUserId: String) {
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyBoard.instantiateViewController(withIdentifier: "ComplainVС") as! ComplainVС
    vc.user = user
    vc.text = message
    vc.messageId = messageId
    vc.fromUserId = fromUserId
    
    self.present(vc, animated: true, completion: nil)
  }
  
  private func chatInvition(_ user: User?) {
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyBoard.instantiateViewController(withIdentifier: "ChatInvitationVC") as! ChatInvitationVC
    vc.user = user
    self.present(vc, animated: true, completion: nil)
  }
  
  func showChatLogVCForUser(_ user: User?) {
    let vc = ReplyAndWriteMessageCVC(collectionViewLayout: UICollectionViewFlowLayout())
    vc.user = user
    vc.nameLabel.text = user?.name
    vc.stausMessage = "1"
    vc.postText.text = "Запрос на открытие личного чата. \nОт первого сообщения зависит разрешит ли \(user!.name!) открыть личный чат с вами!"
    vc.responseToText = "Пользователь \(user!.name!) из чата (-\(String(describing: self.group!.subject!))-) хочет открыть личную переписку с вами!"
    self.present(vc, animated: true, completion: nil)
  }
 
  private func openProfile(_ user: User?) {
    
    let userProfileInfoView = UserProfileInfoView(frame: self.view.frame)
    userProfileInfoView.userNameLabel.text = user!.name
    
    if user!.age != nil {
      userProfileInfoView.ageLabel.text = String(describing:"Возраст: \(user!.age!)")
    } else {
      userProfileInfoView.ageLabelHeightConstraint.constant = 0
      userProfileInfoView.ageLabel.isHidden = true
      userProfileInfoView.ageSeparatorView.isHidden = true
    }
    
    if user!.gender != nil {
      let gen = self.genderValidatorToText(string: user!.gender!)
      userProfileInfoView.genderLabel.text = String(describing: "Пол: \(String(describing: gen))")
    } else {
      userProfileInfoView.genderLabelHeightConstraint.constant = 0
      userProfileInfoView.genderLabel.isHidden = true
      userProfileInfoView.genderSeparatorView.isHidden = true
    }
    
    if user!.aboutSelf != nil {
      userProfileInfoView.aboutSelfTextView.text = String(describing:"O себе: \n\(user!.aboutSelf!)")
      let height = (self.estimateFrameForText(user!.aboutSelf!).height) + 20
      userProfileInfoView.aboutSelfTextViewHeightConstraint.constant = height
    } else {
      userProfileInfoView.aboutSelfTextViewHeightConstraint.constant = 0
      userProfileInfoView.aboutSelfTextView.isHidden = true
      userProfileInfoView.aboutSelfSeparatorView.isHidden = true
    }
    
    if user!.status != nil {
      userProfileInfoView.statusTextView.text = String(describing:"Статус: \n\(user!.status!)")
      let height = (self.estimateFrameForText(user!.status!).height) + 20
      userProfileInfoView.statusTextViewHeightConstraint.constant = height
    } else {
      userProfileInfoView.statusTextViewHeightConstraint.constant = 0
      userProfileInfoView.statusTextView.isHidden = true
      userProfileInfoView.statusSeparatorView.isHidden = true
    }
    
    if user!.orientation != nil {
      let orientation = self.orientationValidatorToText(string: user!.orientation!)
      userProfileInfoView.orientationLabel.text = String(describing:"Нравяться: \(orientation)")
      let height = (self.estimateFrameForText(user!.orientation!).height) + 10
      userProfileInfoView.orientationLabelHeightConstraint.constant = height
    } else {
      userProfileInfoView.orientationLabelHeightConstraint.constant = 0
      userProfileInfoView.orientationLabel.isHidden = true
      userProfileInfoView.orientationSeparatorView.isHidden = true
    }
    
    userProfileInfoView.profileImageView.loadImageUsingCache(user!.profileImageUrl!)
    
    self.view.addSubview(userProfileInfoView)
    
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true) {
      self.inputConteinerView.alpha = 1
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
      handleVideoSelectedForUrl(videoUrl)
    } else {
      handleImageSelectedForInfo(info)
    }
    
    dismiss(animated: true, completion: nil) // выйти с контроллера
  }
  
  // сохраняем видео в базу
  private func handleVideoSelectedForUrl(_ url: URL) {
    let filename = UUID().uuidString + ".mov"
    let ref = Storage.storage().reference().child("messages_movies").child(filename)
    
    let uploadTask = ref.putFile(from: url, metadata: nil) { (metadata, error) in
      if error != nil {
        print(error!)
        return
      }
      ref.downloadURL(completion: { [weak self] (downloadUrl, error) in
        if error != nil {
          print(error!)
          return
        }
        if let videoUrl = downloadUrl?.absoluteString {
          
          if let thumbnailImage = self?.thumbnailimageForVideoUrl(url) {
            
            self?.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
              
              let properties: [String: Any] = ["videoUrl": videoUrl, "imageUrl": imageUrl, "imageWigth": thumbnailImage.size.width, "imageHight": thumbnailImage.size.height]
              
              self?.sendMessagesWithProperties(properties)
            })
          }
        }
      })
    }
    uploadTask.observe(.progress) { [weak self] (snapshot) in
      if let complerionUnitCount = snapshot.progress?.completedUnitCount {
        self?.nameLabel.text = String(complerionUnitCount)
      }
    }
    uploadTask.observe(.success) { [weak self] (snapshot) in
      self?.nameLabel.text = self?.user?.name
    }
  }
  
  // сделать картинку из видео
  private func thumbnailimageForVideoUrl(_ videoUrl:URL) -> UIImage? {
    // переобразовать ссылку в медиа
    let asset = AVAsset(url: videoUrl)
    let imageGenerate = AVAssetImageGenerator(asset: asset)
    
    do  {
      let thumbnailCGImage = try imageGenerate.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
      return UIImage(cgImage: thumbnailCGImage)
    } catch {
      print(error)
    }
    return nil
  }
  
  private func handleImageSelectedForInfo(_ info: [UIImagePickerController.InfoKey: Any]) {
    
    var selectedImageFromPicker: UIImage?
    if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      selectedImageFromPicker = editingImage
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      selectedImageFromPicker = originalImage
    }
    if let selectedImage = selectedImageFromPicker {
      uploadToFirebaseStorageUsingImage(selectedImage) { [weak self] (imageUrl) in
        self?.sendMessageWithImageUrl(imageUrl, image: selectedImage)
      }
    }
  }
  
  private func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
    
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
          if let imageUrl = url?.absoluteString {
            completion(imageUrl)
          }
        })
      }
    }
  }
  
  private func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
    
    let properties = ["imageUrl": imageUrl,"imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
    
    sendMessagesWithProperties(properties)
    
  }
  
  private func sendMessagesWithProperties(_ properties: [String: Any]) {
    
    let ref = Database.database().reference().child("groups").child(group!.subject!).child("messages")
    let childRef = ref.childByAutoId()
    
    let fromId = Auth.auth().currentUser!.uid
    let timestamp = Int(Date().timeIntervalSince1970)
    
    var values = ["fromId": fromId, "timestamp": timestamp] as [String : Any]
    
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
  }
  
  var startFrame: CGRect?
  var blackBackgroundView: UIView?
  var startingImageView: UIImageView?
  
  
  func performZoomInForImageView(_ imageView: UIImageView) {
    startingImageView = imageView
    startingImageView?.isHidden = true
    
    // конвертирует прямоуголтник
    startFrame = imageView.superview?.convert(imageView.frame, to: nil)
    
    let zoomingImageView = UIImageView(frame: startFrame!) // получили картинку по фрейму
    zoomingImageView.image = imageView.image
    zoomingImageView.contentMode = .scaleAspectFit
    zoomingImageView.isUserInteractionEnabled = true
    zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut(_:))))
    
    if let keyWindow = UIApplication.shared.keyWindow {
      blackBackgroundView = UIView(frame: keyWindow.frame)
      blackBackgroundView?.backgroundColor = .black
      blackBackgroundView?.alpha = 0
      keyWindow.addSubview(blackBackgroundView!)
      
      keyWindow.addSubview(zoomingImageView)
      
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
          self.blackBackgroundView?.alpha = 1
          self.inputConteinerView.alpha = 0
          
          let height = self.startFrame!.height / self.startFrame!.width * keyWindow.frame.width
          
          zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
          zoomingImageView.center = keyWindow.center
          
        }, completion: nil)
    }
  }
  
  @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
    if let zoomOutImageView = tapGesture.view as? UIImageView {
      zoomOutImageView.layer.cornerRadius = 16
      zoomOutImageView.clipsToBounds = true
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        zoomOutImageView.frame = self.startFrame!
        self.blackBackgroundView?.alpha = 0
        self.inputConteinerView.alpha = 1
      }) { [weak self] (complete) in
        zoomOutImageView.removeFromSuperview()
        self?.startingImageView?.isHidden = false
      }
    }
  }
  
  @objc func handleUploadTap() {
    
    let imagePickerController = UIImagePickerController()
    
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]

    present(imagePickerController, animated: true) {
      self.inputConteinerView.alpha = 0
    }
  }
  
  @objc func handleBack() {
    dismiss(animated: true, completion: nil)
  }
  
  
  @objc func handleSend() { // отправляем сообщение
    if inputTextField.text != "" {
      let properties = ["text": inputTextField.text!] as [String : Any]
      sendMessagesWithProperties(properties)
    }
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
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatGroupCell
    
    cell.deledate = self
    let message = messages[indexPath.row]
    cell.message = message
    cell.delegate = self
    
    if (arrayBlockUsers.contains(message.fromId!)) {
      cell.textView.isHidden = true
      cell.timeLabel.isHidden = true
      cell.playBtn.isHidden = true
    } else {
      cell.textView.text = message.text
      cell.timeLabel.text = setFormatDislayedTimeAndDate(from: message.timestamp as! TimeInterval, withString: false)
      cell.playBtn.isHidden = message.videoUrl == nil // если видео нет, тогда это тру
    }
    
    setupCell(cell, message: message)

    if let userFromId = message.fromId {
      Database.database().reference().child("users").child(userFromId).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
        
        if let dictionary = snapshot.value as? [String: AnyObject] {
          let currentUser = User(dictionary: dictionary)
          
          if (self?.arrayBlockUsers.contains(snapshot.key))! {
            cell.nameLabel.text = "Пользователь заблокирован"
            cell.nameLabel.font = UIFont.systemFont(ofSize: 10)
            cell.backImageView.isHidden = true
            cell.crownBtn.isHidden = true
            cell.downBlackView.isHidden = true
          } else {
            cell.nameLabel.text = currentUser.name
            
            if let text = message.text { // размер облака сообщения
              
              let widthByText = (self?.estimateFrameForText(text).width)! + 35
              let widthByName = (self?.estimateFrameForText(currentUser.name!).width)! + 35
              
              if widthByText >= widthByName { // по размеру текста или имени
                cell.bubbleWidthAnchor?.constant = widthByText
              } else {
                cell.bubbleWidthAnchor?.constant = widthByName
              }
              
              cell.textView.isHidden = false
            } else if message.imageUrl != nil {
              cell.bubbleWidthAnchor?.constant = 200
              cell.textView.isHidden = true
            }
            
            if let profileImageView = currentUser.profileImageUrl {
              cell.profileImageView.loadImageUsingCache(profileImageView)
            }
          }
        }
      }, withCancel: nil)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    var height: CGFloat = 80
    let message = messages[indexPath.row]
    
    if (arrayBlockUsers.contains(message.fromId!)) {
      height = 47
      
    } else {
      if let text = message.text {
        height = estimateFrameForText(text).height + 65
        
      } else if let imageWidht = message.imageWidth, let imageHight = message.imageHeight {
        // сделали размер пропорционально
        height = CGFloat(imageHight / imageWidht * 200) + 30
      }
    }
    return CGSize(width: view.frame.width, height: height)
  }
}
