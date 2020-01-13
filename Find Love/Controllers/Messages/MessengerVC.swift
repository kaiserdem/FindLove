//
//  MessagesTableVC.swift
//  Find Love
//
//  Created by Kaiserdem on 26.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MessengerVC: UIViewController {
  
  @IBOutlet weak var chatContentView: UIView!
  @IBOutlet weak var messageAllContentView: UIView!
  @IBOutlet weak var newMessageConteinerView: UIView!
  @IBOutlet weak var messageBarBtnView: UIView!
  @IBOutlet weak var chatBarBtnView: UIView!
  @IBOutlet weak var newMessageBarBtnView: UIView!
  @IBOutlet weak var topBarView: UIView!
  @IBOutlet weak var backViewTable: UIView!
  
  
  let tableView = UITableView()
  let cellId = "Cell"
  var users = [User]()
  var messages = [Message]()
  var messagesDictionary = [String: Message]()
  var menuVC: MenuVC?
  var timer: Timer?
  
  let chatVC = ChatVC()
  let newMessageVC = NewMessageVC()
  let messagesAllVC = MessagesVC()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupTopBarGesture()
    showMessageVC()
    messagesBtnClick()
  }

  func showMessageVC() {
    addChild(messagesAllVC)
    
    chatVC.removeFromParent()
    chatVC.dismiss(animated: true, completion: nil)
    
    
    chatContentView.isHidden = true
    newMessageConteinerView.isHidden = true
    messageAllContentView.isHidden = false
    
    backViewTable.addSubview(messagesAllVC.view)
    messagesAllVC.didMove(toParent: self)
    
  }
  
  func showChatVC() {
    addChild(chatVC)
    
    newMessageConteinerView.isHidden = true
    messageAllContentView.isHidden = true
    chatContentView.isHidden = false
    
    backViewTable.addSubview(chatVC.view)
    chatVC.didMove(toParent: self)
    
  }
  
  func showNewMessageVC() {
    addChild(newMessageVC)
    
    chatContentView.isHidden = true
    messageAllContentView.isHidden = true
    newMessageConteinerView.isHidden = false

    backViewTable.addSubview(newMessageVC.view)
    newMessageVC.didMove(toParent: self)
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    messageBarBtnView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    chatBarBtnView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    newMessageBarBtnView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
  }

  private func setupTopBarGesture() {
 
    let messageGestures = UITapGestureRecognizer(target: self, action:  #selector (messageBtnAction (_:)))
    let chatBtnGestures = UITapGestureRecognizer(target: self, action:  #selector (chatBtnAction (_:)))
    let writeBtnGestures = UITapGestureRecognizer(target: self, action:  #selector (newMessageBtnAction (_:)))
    
    self.messageBarBtnView.addGestureRecognizer(messageGestures)
    self.chatBarBtnView.addGestureRecognizer(chatBtnGestures)
    self.newMessageBarBtnView.addGestureRecognizer(writeBtnGestures)
  
  }
  func messagesBtnClick() {
    self.messageBarBtnView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    self.messageBarBtnView.layer.shadowOffset = CGSize(width: 0.5, height: -1.0)
    self.messageBarBtnView.layer.shadowRadius = 1.5
    self.messageBarBtnView.layer.shadowOpacity = 0.2
    
    self.chatBarBtnView.backgroundColor = #colorLiteral(red: 0.2551150906, green: 0.2551150906, blue: 0.2551150906, alpha: 1)
    self.chatBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.chatBarBtnView.layer.shadowRadius = 0
    self.chatBarBtnView.layer.shadowOpacity = 0
    
    self.newMessageBarBtnView.backgroundColor = #colorLiteral(red: 0.2551150906, green: 0.2551150906, blue: 0.2551150906, alpha: 1)
    self.newMessageBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.newMessageBarBtnView.layer.shadowRadius = 0
    self.newMessageBarBtnView.layer.shadowOpacity = 0
  }
  
  func chatBtnClick() {
    self.chatBarBtnView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    self.chatBarBtnView.layer.shadowOffset = CGSize(width: 0.5, height: -1.0)
    self.chatBarBtnView.layer.shadowRadius = 1.5
    self.chatBarBtnView.layer.shadowOpacity = 0.2
    
    self.newMessageBarBtnView.backgroundColor = #colorLiteral(red: 0.2551150906, green: 0.2551150906, blue: 0.2551150906, alpha: 1)
    self.newMessageBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.newMessageBarBtnView.layer.shadowRadius = 0
    self.newMessageBarBtnView.layer.shadowOpacity = 0
    
    self.messageBarBtnView.backgroundColor = #colorLiteral(red: 0.2551150906, green: 0.2551150906, blue: 0.2551150906, alpha: 1)
    self.messageBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.messageBarBtnView.layer.shadowRadius = 0
    self.messageBarBtnView.layer.shadowOpacity = 0
  }
  
  func newMessageBtnClick() {
    self.newMessageBarBtnView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    self.newMessageBarBtnView.layer.shadowOffset = CGSize(width: 0.5, height: -1.0)
    self.newMessageBarBtnView.layer.shadowRadius = 1.5
    self.newMessageBarBtnView.layer.shadowOpacity = 0.2
    
    self.messageBarBtnView.backgroundColor = #colorLiteral(red: 0.2551150906, green: 0.2551150906, blue: 0.2551150906, alpha: 1)
    self.messageBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.messageBarBtnView.layer.shadowRadius = 0
    self.messageBarBtnView.layer.shadowOpacity = 0
    
    self.chatBarBtnView.backgroundColor = #colorLiteral(red: 0.2551150906, green: 0.2551150906, blue: 0.2551150906, alpha: 1)
    self.chatBarBtnView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.chatBarBtnView.layer.shadowRadius = 0
    self.chatBarBtnView.layer.shadowOpacity = 0
  }
  
  @objc func messageBtnAction(_ sender:UITapGestureRecognizer){
    showMessageVC()
    messagesBtnClick()
  }
  
  @objc func chatBtnAction(_ sender:UITapGestureRecognizer){
    showChatVC()
    chatBtnClick()
  }
  
  @objc func newMessageBtnAction(_ sender:UITapGestureRecognizer){
    showNewMessageVC()
    newMessageBtnClick()
  }

}
