//
//  MenuVC.swift
//  Find Love
//
//  Created by Kaiserdem on 24.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

protocol ProtocolProfileCellsDelegate: class {
  func changeAboutSelfTapped(cell: AboutSelfViewCell)
  func changeStatusTapped(cell: StatusViewCell)
  func changeOrientationTapped(cell: OrientationViewCell)
  func changeInfoTapped(cell: InformationViewCell)
  func changeImageTapped(cell: InformationViewCell)
  func settingsButtonTapped(cell: SettingsViewCell)
}

class ProfileVC: UIViewController, ProtocolProfileCellsDelegate {
  
  @IBOutlet weak var backView: UIView!
  
  var startFrame: CGRect?
  var blackBackgroundView: UIView?
  var startingImageView: UIImageView?
  
  let tableView = UITableView()
  let defaults = UserDefaults.standard
  lazy var arrayBlockUsers = defaults.stringArray(forKey: "arrayBlockUsers") ?? [String]()
  var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let objUser = UserDefaults.standard.retrieve(object: User.self, fromKey: "currentUserKey")
    user = objUser
    
    navigationController?.navigationBar.isHidden = true
    
    uploadTableView()
   
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide(sender:))))
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tableView.allowsSelection = false 
    tableView.tableFooterView = UIView() // убрать все что ниже
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    observeChatInvitation()
    observeUser()
  }
  
  private func uploadTableView() {
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.backgroundColor = .black
    
    self.view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    
    tableView.register(UINib(nibName: "InformationViewCell", bundle: nil), forCellReuseIdentifier: "InformationViewCell")
    tableView.register(UINib(nibName: "StatusViewCell", bundle: nil), forCellReuseIdentifier:"StatusViewCell")
    tableView.register(UINib(nibName: "OrientationViewCell", bundle: nil), forCellReuseIdentifier: "OrientationViewCell")
    tableView.register(UINib(nibName: "AboutSelfViewCell", bundle: nil), forCellReuseIdentifier:"AboutSelfViewCell")
    tableView.register(UINib(nibName: "SettingsViewCell", bundle: nil), forCellReuseIdentifier: "SettingsViewCell")
    
    tableView.allowsMultipleSelectionDuringEditing = true
  }
  
  private func observeUser() {
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let ref = Database.database().reference().child("users").child(uid)
    ref.observe(.value, with: { [weak self] (snapshot) in
      
      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
      
      let user = User(dictionary: dictionary)
     
      self?.user = user
      
      UserDefaults.standard.save(user, forKey: "currentUserKey")
      
      DispatchQueue.main.async {
        self?.tableView.reloadData()
        self?.tableView.layoutIfNeeded()
      }
      
      }, withCancel: nil)
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
  
   func changeAboutSelfTapped(cell: AboutSelfViewCell) {
    let view = AboutSelfView(frame: self.view.frame)
    if user?.aboutSelf != nil {
      view.aboutSelfTextView.text = user!.aboutSelf!
      view.beforeAboutSelfText = user!.aboutSelf!
      let height = estimateFrameForText(user!.status!).height + 10
      view.heightConstraintAboutSelfTextView.constant = height
    } else {
      view.aboutSelfTextView.text = "Опишите себя, свои интересы и увлечения"
      view.beforeAboutSelfText = "Опишите себя, свои интересы и увлечения"
    }
    self.view.addSubview(view)
  }
  
  func changeStatusTapped(cell: StatusViewCell) {
    let view = StatusView(frame: self.view.frame)
    if user?.status != nil {
      view.statusTextView.text = user!.status!
      view.beforeStatusText = user!.status!
      let height = estimateFrameForText(user!.status!).height + 10
      view.heightConstraintStatusTextView.constant = height
    } else {
      view.statusTextView.text = "Тут пока пусто, опишите свое настроение"
      view.beforeStatusText = "Тут пока пусто, опишите свое настроение"
    }
    self.view.addSubview(view)
  }
  
  func changeOrientationTapped(cell: OrientationViewCell) {
    let view = OrientationView(frame: self.view.frame)
    if user?.orientation != nil {
      view.orientationBtn.setTitle(orientationValidatorToText(string: user!.orientation!), for: .normal)
      view.beforeOrientation = orientationValidatorToText(string: user!.orientation!)
    } else {
      view.orientationBtn.setTitle("Девушки или парни", for: .normal)
      view.beforeOrientation = "Девушки или парни"
    }
    self.view.addSubview(view)
  }
  
  func changeInfoTapped(cell: InformationViewCell) {
    let view = InfornatioView(frame: self.view.frame)
    view.beforeName = (user?.name)!
    view.nameTextField.text = user?.name
    if user?.age !=  nil {
      view.ageBtn.setTitle(String(describing: user!.age!), for: .normal)
      view.beforeAge = String(describing: user!.age!)
    } else {
      view.ageBtn.setTitle("Тут пока пусто", for: .normal)
      view.beforeAge = String(describing:"Тут пока пусто")
    }
    if user?.gender != nil {
      view.beforeGender = genderValidatorToText(string: (user?.gender!)!)
      view.genderBtn.setTitle(genderValidatorToText(string: (user?.gender!)!), for: .normal)
    } else {
      view.genderBtn.setTitle("Выбрать из списка", for: .normal)
      view.beforeGender = "Выбрать из списка"
    }
    self.view.addSubview(view)
  }
  
  func settingsButtonTapped(cell: SettingsViewCell) {
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
    self.present(newViewController, animated: true, completion: nil)
  }
  
  func changeImageTapped(cell: InformationViewCell) {
    handleSelectProfileImageView()
  }
  
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
        
        let height = self.startFrame!.height / self.startFrame!.width * keyWindow.frame.width
        
        zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
        zoomingImageView.center = keyWindow.center
        
      }, completion: nil)
    }
  }
  
  @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
    if let zoomOutImageView = tapGesture.view as? UIImageView {
      DispatchQueue.main.async {
        zoomOutImageView.layer.cornerRadius = 52
        zoomOutImageView.clipsToBounds = true
      }
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        zoomOutImageView.frame = self.startFrame!
        self.blackBackgroundView?.alpha = 0
      }) { [weak self] (complete) in
        zoomOutImageView.removeFromSuperview()
        self?.startingImageView?.isHidden = false
      }
    }
  }
  
  @objc func handelZoomTap(_ gestureRecognizer: UITapGestureRecognizer) {
    if let imageView = gestureRecognizer.view as? UIImageView {
      performZoomInForImageView(imageView)
    }
  }
  
  @objc func keyboardWillHide(sender: NSNotification) {
    let infornatioView = InfornatioView(frame: self.view.frame)
    infornatioView.ageBtn.endEditing(true)
    infornatioView.genderBtn.endEditing(true)
    view.endEditing(true)
  }
  
  func calculateHeight(_ properties: String) -> CGFloat {
    var heightReturn: CGFloat = 0
        switch properties {
        case "status":
          if user!.status != nil {
            heightReturn = estimateFrameForText(user!.status!).height + 80
            if heightReturn < 100 {
              return 100
            }
            return heightReturn
          } else {
            return 100
          }
        case "aboutSelf":
          if user!.aboutSelf != nil {
            heightReturn = estimateFrameForText(user!.aboutSelf!).height + 20
            if heightReturn < 100 {
              return 100
            }
            return heightReturn
          } else {
            return 100
          }
        default:
          break
        }
    return CGFloat()
  }
  
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func handleSelectProfileImageView() {
    let picker = UIImagePickerController()

    picker.delegate = self
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

    var selectedImageFromPicker: UIImage?
    if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      selectedImageFromPicker = editingImage
    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      selectedImageFromPicker = originalImage
    }
    if let selectedImage = selectedImageFromPicker {
      
      guard let imageUrl = user?.profileImageUrl else { return }
     
      let ref = Storage.storage().reference().child("profile_images")
      let storageRef = ref.storage.reference(forURL: imageUrl)

      storageRef.delete { error in
        if let error = error {
          print(error)
        } else {
          print("File deleted successfully")
        }
      }
      
      let imageName = NSUUID().uuidString
      let refImagePath = ref.child("\(imageName).png")

      if let uploadData = selectedImage.jpegData(compressionQuality: 0.75) {
        refImagePath.putData(uploadData, metadata: nil) { [weak self]  (metadata, error) in
          if error != nil {
            print(error?.localizedDescription as Any)
            return
          }
          refImagePath.downloadURL(completion: { (url, error) in
            if error != nil {
              print(error?.localizedDescription as Any)
              return
            }
            if let imageUrl = url?.absoluteString {
              let refUsersDatabase = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
              
              self?.user?.profileImageUrl = imageUrl
              UserDefaults.standard.save(self?.user, forKey: "currentUserKey")
              
              let values = ["profileImageUrl": imageUrl] as [String : Any]
              refUsersDatabase.updateChildValues(values)
            }
          })
        }
      }
    }
    dismiss(animated: true) {
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
      }
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
   // let objUser = UserDefaults.standard.retrieve(object: User.self, fromKey: "currentUserKey")
   // user = objUser
 
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "InformationViewCell", for: indexPath) as! InformationViewCell
      cell.delegate = self
      
      if user?.name != nil {
        cell.nameLabel.text = user!.name!
      }
      
      if user!.gender != nil {
        cell.genderLabel.textColor = .white
        let gender = user!.gender!
        let genderString = genderValidatorToText(string: gender)
        cell.genderLabel.text = "Пол: \(genderString)"
      } else {
        cell.genderLabel.textColor = #colorLiteral(red: 1, green: 0.5693903705, blue: 0.4846021499, alpha: 1)
        cell.genderLabel.text = "Введите свой пол"
      }
      if user!.age != nil {
        cell.ageLabel.textColor = .white
        let ageString = String(describing: user!.age!)
        cell.ageLabel.text = String(describing:"Возраст: \(ageString)")
      } else {
        cell.ageLabel.textColor = #colorLiteral(red: 1, green: 0.5693903705, blue: 0.4846021499, alpha: 1)
        cell.ageLabel.text = "Введите свой возраст"
      }
      if let profileImageView = user!.profileImageUrl {
        cell.profileImageView.loadImageUsingCache(profileImageView)
        cell.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelZoomTap)))
      }
    }
    if indexPath.row == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "StatusViewCell", for: indexPath) as! StatusViewCell
      cell.delegate = self
      
      if user!.status != nil {
        cell.statusTextView.textColor = .white
        cell.statusTextView.text = user?.status
      } else {
        cell.statusTextView.text = "Тут пока пусто, опишите свое настроение"
        cell.statusTextView.textColor = #colorLiteral(red: 1, green: 0.5693903705, blue: 0.4846021499, alpha: 1)
      }
    }
    if indexPath.row == 2 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "OrientationViewCell", for: indexPath) as! OrientationViewCell
      cell.delegate = self
      
      if user!.orientation != nil {
        cell.orientationLabel.textColor = .white
        cell.orientationLabel.text = orientationValidatorToText(string: user!.orientation!)
      } else {
        cell.orientationLabel.text = "Введите свой предпочтения"
        cell.orientationLabel.textColor = #colorLiteral(red: 1, green: 0.5693903705, blue: 0.4846021499, alpha: 1)
      }
    }
    if indexPath.row == 3 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "AboutSelfViewCell", for: indexPath) as! AboutSelfViewCell
      cell.delegate = self
      
      if user!.aboutSelf != nil {
        cell.aboutSelfTextView.textColor = .white
        cell.aboutSelfTextView.text = user!.aboutSelf
      } else {
        cell.aboutSelfTextView.textColor = #colorLiteral(red: 1, green: 0.5693903705, blue: 0.4846021499, alpha: 1)
        cell.aboutSelfTextView.text = "Опишите себя, свои интересы и увлечения"
      }
    }
    if indexPath.row == 4 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsViewCell", for: indexPath) as! SettingsViewCell
      cell.delegate = self
    }
    return UITableViewCell()
    
  }
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if indexPath.row == 0 {
      return 250
      
    } else if indexPath.row == 1 {
      return calculateHeight("status")
  
    } else if indexPath.row == 2 {
      return 100
      
    } else if indexPath.row == 3 {
      return calculateHeight("aboutSelf")
      
    } else if indexPath.row == 4 {
      return 60
      
    } else {
      return 0
    }
  }
}
