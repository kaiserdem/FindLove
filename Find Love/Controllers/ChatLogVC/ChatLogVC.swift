//
//  ChatLogVC.swift
//  Find Love
//
//  Created by Kaiserdem on 27.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class ChatLogVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
  
//  var user: User? {
//    didSet {
//      navigationItem.title = user?.name
//
//      observeMessages() // наблюдать сообщения по Id
//    }
//  }
  
  var messages = [Message]() // масив всех сообщений
  
//  func observeMessages() {
//    guard let uid = Auth.auth().currentUser?.uid else { return } // uid текущего юзера
//
//    // ветка нашего юзера, все сообщения
//    let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
//
//    // проверяем новые ветки
//    userMessagesRef.observe(.childAdded, with: { (snapshot) in
//      print("1")
//      let messageId = snapshot.key // ключ из ветки юзера
//      // ссылка на это сообщение
//      let messageRef = Database.database().reference().child("messages").child(messageId)
//      // просматриваем значение сообщения
//      messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
//        // значение кладем в масив
//        guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
//
//        let message = Message(dictionary: dictionary) // сообщения в масиве
//
//        if message.chatPartnerId() == self.user?.id { // проверка
//          self.messages.append(message) // добавляем в новый масив
//          DispatchQueue.main.async {
//            self.collectionView?.reloadData()
//          }
//        }
//      }, withCancel: nil)
//    }, withCancel: nil)
//  }
  
  lazy var inputTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Ведите сообщение..."
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self // подписали делегат
    return textField
  }()
  
  let cellId = "cellId"
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.alwaysBounceVertical = true
    collectionView?.backgroundColor = UIColor.white
    // регистрация ячейки
    //collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
    setupInputComponents()
  }
  
  // кол елементов в секции
//  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return messages.count //сколько сообщений в масиве
//  }
//  
//  // возвращает ячейку по елементу
//  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    // переиспользовать ячейку
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
//    
//    let message = messages[indexPath.item]  // масив всех сообщений
//    cell.textView.text = message.text // в ячейкц текст из масива
//    return cell
//  }
//  
//  //размер каждой ячейки
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return CGSize(width: view.frame.width, height: 80)
//  }
  
  
  
  //  //размер каждой ячейки
  //  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  //    let height: CGFloat = 80
  //
  //    return CGSize(width: view.frame.width, height: 80)
  //  }
  //    // расчитать размер вю для написаното текста
  //  private func estimateFrameForText(_ text: String) -> CGRect {
  //    let size = CGSize(width: 200, height: 1000)
  //    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
  //
  //    return NSString(string: text).boundingRect(with: size, options: options, attributes: [nsa : UIFont.systemFont(ofSize: 16)]?, context: <#T##NSStringDrawingContext?#>) //boundingRect возвращает размер из строки
  //  }
  
  func setupInputComponents() { // компоненты контроллера
    let conteinerView = UIView()
    conteinerView.backgroundColor = .gray
    conteinerView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(conteinerView)
    
    conteinerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    conteinerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    conteinerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    conteinerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    let sendButton = UIButton(type: .system)
    sendButton.setTitle("Отправить", for: .normal)
    sendButton.setTitleColor(.black, for: .normal)
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    conteinerView.addSubview(sendButton)
    
    sendButton.rightAnchor.constraint(equalTo: conteinerView.rightAnchor, constant: -10).isActive = true
    sendButton.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
    sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    sendButton.heightAnchor.constraint(equalTo: conteinerView.heightAnchor).isActive = true
    
    conteinerView.addSubview(inputTextField)
    
    inputTextField.leftAnchor.constraint(equalTo: conteinerView.leftAnchor, constant: 8).isActive = true
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
    
  }
  
  @objc func handleSend() { // отправляем сообщение
    
    let ref = Database.database().reference().child("messages") // новая ветка
    let childRef = ref.childByAutoId() // вернет всех детей
    //let toId = user!.id! // айди получателя
    //let fromId = Auth.auth().currentUser!.uid // айди отправителя
    //let timestamp = Int(NSDate().timeIntervalSince1970) // время
    // отправляем масив данных
    let values = ["text": inputTextField.text!, "name": "user"] as [String : Any]
    childRef.updateChildValues(values)
    //let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
//
//    childRef.updateChildValues(values) { (error, ref) in // загрузить значение веток
//      if error != nil { // если есть ошибка
//        print(error!) // выходим из функции
//        return
//      }
//      // новая ветка,сообщения по конкретном пользователю, кто отправил
//      let userMessageRef = Database.database().reference().child("user-messages").child(fromId)
//
//      let messageId = childRef.key // ключ нашего сообшения
//      userMessageRef.updateChildValues([messageId: 1])// в новую ветку кладем ключ
//
//    }
  }
   // текстовое поле возврвщвет
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    handleSend()
    return true
  }
}
