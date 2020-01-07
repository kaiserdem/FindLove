//
//  SearchVC.swift
//  Find Love
//
//  Created by Kaiserdem on 03.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
  
  @IBOutlet weak var searchSettingBtn: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var reviewCVCell: String = "ReviewCVCell"
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.isPagingEnabled = true
      collectionView.showsHorizontalScrollIndicator = false
      collectionView.backgroundColor = UIColor.black
      
      collectionView.register(UINib(nibName: "ReviewCVCell", bundle: nil), forCellWithReuseIdentifier: "ReviewCVCell")
      
      searchSettingBtn.setImage(UIImage(named: "setting")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
      searchSettingBtn.imageView?.tintColor = .white
     
  }

  @IBAction func searchSettingBtnAction(_ sender: Any) {
    
  }
  
}

extension SearchVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCVCell", for: indexPath) as! ReviewCVCell
    cell.profileImageView.image = #imageLiteral(resourceName: "image2")
    cell.nameLabel.text = "Oleg"
    cell.infoLabel.text = "Kyiv"
    return cell
  }
  
  
}
