//
//  ComplainVС.swift
//  Find Love
//
//  Created by Kaiserdem on 16.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class ComplainVС: UIViewController {

  @IBOutlet weak var commentsTextView: UITextView!
  @IBOutlet var checkButtons: [UIButton]!
  @IBOutlet weak var cencelBtn: UIButton!
  @IBOutlet weak var sendComplainBtn: UIButton!
  
  
  var typeComplaint = ""
  var arrayOfComplaints = ["Не пристойное фото", "Мошенничество", "Преследоване,угрозы", "Самоубийство,увечье", "СПАМ"]
  
  var user: User?
  var text = ""
  var fromUserId = ""
  var messageId = ""
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cencelBtn.setImage(UIImage(named: "cancel")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
    cencelBtn.tintColor = .white
    
    for i in checkButtons {
      i.layer.cornerRadius = 15
    }
    commentsTextView.layer.cornerRadius = 8
    sendComplainBtn.layer.cornerRadius = 8
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide(sender:))))
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func keyboardWillShow(sender: NSNotification) {
    self.view.frame.origin.y = -180
    commentsTextView.text = ""
  }
  
  @objc func keyboardWillHide(sender: NSNotification) {
    self.view.frame.origin.y = 0
    view.endEditing(true)
  }

  @IBAction func closeButtonAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func sendComplainTapped(_ sender: Any) {
    
    self.view.frame.origin.y = 0
    view.endEditing(true)
    
    if commentsTextView.text.count < 5 || commentsTextView.text == "Комментарий (обязательно)" {
      let view = CustomAlertWarning(frame: self.view.frame)
      view.textTextView.text = "Текст не может быть меньше 5 ти символов"
      self.view.addSubview(view)
      return
    }
    
    let textComplain = String(describing: "Аргумен жалобы: \(typeComplaint),\n Комментарий: \(commentsTextView.text!),\n from User Id: \(fromUserId),\n Message Id: \(messageId), \n Text: \(text)")
    
    sendMessageToModerator(textComplain)
    
    dismiss(animated: true, completion: nil)
    
  }
  
  private func sendMessageToModerator(_ text: String) {
    
    let ref = Database.database().reference().child("messages")
    let childRef = ref.childByAutoId()
    let toId = "LMyGd4zB9jfN4qBOAc1FdVrtSwl2"
    let fromId = Auth.auth().currentUser!.uid
    let timestamp = Int(Date().timeIntervalSince1970)
    
    var values = [ "toId": toId, "fromId": fromId, "timestamp": timestamp, "text": text] as [String : Any]
    
    //print(childRef)
    
    childRef.updateChildValues(values) { (error, ref) in
      if error != nil {
        print(error!)
        return
      }
    }
    
    let refToFrom = Database.database().reference().child("user-messages").child(toId).child(fromId)
    
    let messageId3 = childRef.key
    let values3 = [messageId3: 1] as! [String : Any]
    
    //print(refToFrom)
    
    refToFrom.updateChildValues(values3) { (error, ref) in
      if error != nil {
        print(error!)
        return
      }
    }
    
//    let refFromTo = Database.database().reference().child("user-messages").child(fromId).child(toId)
//    
//    let messageId = childRef.key
//    let values2 = [messageId: 1] as! [String : Any]
//    
//    print(refFromTo) // 
//    
//    refFromTo.updateChildValues(values2) { (error, ref) in
//      if error != nil {
//        print(error!)
//        return
//      }
//    }
    
    
  }
  
  
  @IBAction func ckeckTappedAction(_ sender: UIButton) {

    for button in checkButtons {
      if button.tag == sender.tag {
        let index = sender.tag - 1
        typeComplaint = arrayOfComplaints[index]
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
      } else {
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .normal)
      }
    }
  }

}
