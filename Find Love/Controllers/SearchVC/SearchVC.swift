//
//  SearchVC.swift
//  Find Love
//
//  Created by Kaiserdem on 03.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SearchVC: UIViewController {
  
  @IBOutlet weak var searchSettingBtn: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var reviewCVCell: String = "ReviewCVCell"
  
  var users = [User]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      observeUser()
      
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.isPagingEnabled = true
      collectionView.showsHorizontalScrollIndicator = false
      collectionView.backgroundColor = UIColor.black
      
      collectionView.register(UINib(nibName: "ReviewCVCell", bundle: nil), forCellWithReuseIdentifier: "ReviewCVCell")
      
      searchSettingBtn.setImage(UIImage(named: "setting")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      searchSettingBtn.imageView?.tintColor = .white
     
  }
  
  func observeUser() {
    let ref = Database.database().reference().child("users")
    ref.observe(.childAdded, with: { (snapshot) in
      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
      
      let user = User(dictionary: dictionary)
      self.users.append(user)
      
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }

    }, withCancel: nil)
    
  }

  @IBAction func searchSettingBtnAction(_ sender: Any) {
    
  }
  
}

extension SearchVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return users.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCVCell", for: indexPath) as! ReviewCVCell
    
    let user = users[indexPath.row]
    
      cell.nameLabel.text = user.name
      cell.infoLabel.text = user.email
      
      if let profileImageView = user.profileImageUrl {
        cell.profileImageView.loadImageUsingCachWithUrlString(profileImageView)
      }
    
    return cell
  }
  
  
}
