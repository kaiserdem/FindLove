//
//  AppDelegate.swift
//  Find Love
//
//  Created by Kaiserdem on 24.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  
  func checkIfUserIsLogedIn() { // проверка если пользователь вошел в систему
    
    if Auth.auth().currentUser?.uid == nil { // если мы не вошли
      
      loadHelloVC()
    } else {
      loadFeedVC()
    }
  }
  
  func loadHelloVC() {
    let nav1 = UINavigationController()
    let mainView = HelloVC(nibName: "HelloVC", bundle: nil)
    nav1.viewControllers = [mainView]
    self.window!.rootViewController = nav1
    self.window?.makeKeyAndVisible()
  }
  
  func loadFeedVC() {
    
  let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "CustomTabBar") as UIViewController
  self.window = UIWindow(frame: UIScreen.main.bounds)
  self.window?.rootViewController = initialViewControlleripad
  self.window?.makeKeyAndVisible()
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    FirebaseApp.configure()
    checkIfUserIsLogedIn()
    
    UIApplication.shared.statusBarStyle = .lightContent
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {

  }

  func applicationWillEnterForeground(_ application: UIApplication) {

  }

  func applicationDidBecomeActive(_ application: UIApplication) {

  }

  func applicationWillTerminate(_ application: UIApplication) {

  }


}

