//
//  TestVC.swift
//  Find Love
//
//  Created by Kaiserdem on 06.02.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class TestVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ProtocolSettingsCellDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(UINib(nibName: "SettingsSwitchCell", bundle: nil), forCellReuseIdentifier: "SettingsSwitchCell")
    tableView.register(UINib(nibName: "SettingButtonNextCell", bundle: nil), forCellReuseIdentifier: "SettingButtonNextCell")
  }
  
  func nextButtonTapped(cell: SettingButtonNextCell) {
    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
    print(indexPath.row)
    print("nextButtonTapped")
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingButtonNextCell", for: indexPath) as! SettingButtonNextCell
      cell.nextButtonOutlet.setTitle("vewdweqdewd", for: .normal)
      cell.delegate = self
    }
    
    if indexPath.row == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
        cell.outletLabel.text = "ewfewfewfweq"
    }
    
    return UITableViewCell()
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

