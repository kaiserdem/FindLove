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

class PostVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageZomable {
  
  
  var user: User? {
    didSet {
    }
  }
  
  var posts = [Post]()
  var postDictionary = [String: Post]()
  
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
    uploadImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
    uploadImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    let sendButton = UIButton(type: .system)
    sendButton.setTitle("Опубликовать", for: .normal)
    sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    sendButton.setTitleColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), for: .normal)
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    conteinerView.addSubview(sendButton)
    
    sendButton.rightAnchor.constraint(equalTo: conteinerView.rightAnchor, constant: -10).isActive = true
    sendButton.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
    sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
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
    collectionView?.backgroundColor = UIColor.white
    collectionView?.keyboardDismissMode = .interactive
    
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
    topConteinerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
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

  }
  

  
  // принимает текст возвращает размер
  private func estimateFrameForText(_ text: String) -> CGRect {
    
    let size = CGSize(width: 200, height: 1000)
    
    // текст прислоняеться к левому краю и использует пренос строки
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
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
      ref.downloadURL(completion: { (downloadUrl, error) in
        if error != nil {
          print(error!)
          return
        }
        if let videoUrl = downloadUrl?.absoluteString {
          
          if let thumbnailImage = self.thumbnailimageForVideoUrl(url) {
            
            self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
              
              let properties: [String: Any] = ["videoUrl": videoUrl, "imageUrl": imageUrl, "imageWigth": thumbnailImage.size.width, "imageHight": thumbnailImage.size.height]
              
              self.sendMessagesWithProperties(properties)
            })
          }
        }
      })
    }
    uploadTask.observe(.progress) { (snapshot) in
      if let complerionUnitCount = snapshot.progress?.completedUnitCount {
        //self.nameLabel.text = String(complerionUnitCount)
      }
    }
    uploadTask.observe(.success) { (snapshot) in
      //self.nameLabel.text = self.user?.name
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
      uploadToFirebaseStorageUsingImage(selectedImage) { (imageUrl) in
        self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
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
    
    let ref = Database.database().reference().child("posts")
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
    
    dismiss(animated: true, completion: nil)

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
        self.inputConteinerView.alpha = 0
      }) { (complete) in
        zoomOutImageView.removeFromSuperview()
        self.startingImageView?.isHidden = false
      }
    }
  }
  
  @objc func handleUploadTap() {
    
    let imagePickerController = UIImagePickerController()
    
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
    
    present(imagePickerController, animated: true, completion: nil)
  }
  
  @objc func handleBack() {
    
    dismiss(animated: true, completion: nil)
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
 
}
