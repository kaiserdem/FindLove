//
//  MenuVC.swift
//  Find Love
//
//  Created by Kaiserdem on 24.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class MenuVC: UIViewController {

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var titleNameLable: UILabel!
  @IBOutlet weak var messagesBtn: UIButton!
  @IBOutlet weak var logoutBtn: UIButton!
  
//  override var prefersStatusBarHidden: Bool {
//    return true
//  }
  
  override func viewDidLoad() {
        super.viewDidLoad()

    navigationController?.navigationBar.isHidden = true
    checkIfUserIsLogedIn()
    
  }

  func checkIfUserIsLogedIn() { // проверка если пользователь вошел в систему
    
    if Auth.auth().currentUser?.uid == nil { // если мы не вошли
      handleLogout()
    } else {
      fetchUserAndSetupNavBarTitle()
    }
  }
  
  func handleLogout() { // выйти
    do {
      try Auth.auth().signOut()
    } catch let logoutError {
      print(logoutError)
    }
//    let controll = HelloVC.init(nibName: "HelloVC", bundle: nil)
//    self.navigationController?.pushViewController(controll, animated: true)
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    _ = appDelegate.loadHelloVC()
  }
  
  
  func fetchUserAndSetupNavBarTitle() { // загружаем пользователя и сохраняем титул
    guard let uid = Auth.auth().currentUser?.uid else { // если currentUser 0 тогда выходим
      return
    }
    // получаем uid по из базы данных, берем значение
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        let user = User(dictionary: dictionary)
        self.setupNavBarWithUser(user)
      }
    }, withCancel: nil)
  }
  
  func setupNavBarWithUser(_ user: User) { //загрузить данные
    titleNameLable.text = user.name
    if let profileImageUrl = user.profileImageUrl {
      profileImageView.loadImageUsingCachWithUrlString(profileImageUrl)
    }
  }
  
  @IBAction func logoutBtnAction(_ sender: Any) {
    handleLogout()
  }
  
  @IBAction func messagesBtnAction(_ sender: Any) {
    let vc = MessagesVC()
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
