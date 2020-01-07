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
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    
    if Auth.auth().currentUser?.uid == nil { // если мы не вошли
      
      loadHelloVC()
    } else {
      loadTabBarControllers()
    }
  }
  
  func loadHelloVC() {
    let nav1 = UINavigationController()
    let mainView = HelloVC(nibName: "HelloVC", bundle: nil)
    nav1.viewControllers = [mainView]
    self.window!.rootViewController = nav1
    self.window?.makeKeyAndVisible()
  }
  
  func loadTabBarControllers() {
    
    let tabBarController = UITabBarController()
    
    let feedVC = FeedVC(nibName: "FeedVC", bundle: nil)
    feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "feed"),
                                     tag: 1)
    
    let menuVC = MenuVC(nibName: "MenuVC", bundle: nil)
    menuVC.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(named: "menu1"),
                                     tag: 2)
    
    let searchVC = SearchVC(nibName: "SearchVC", bundle: nil)
    searchVC.tabBarItem = UITabBarItem(title: "Love", image: UIImage(named: "search"),
                                       tag: 3)
    
    let messagesVC = MessagesVC(nibName:"MessagesVC", bundle: nil)
    messagesVC.tabBarItem = UITabBarItem(title: "Messages", image:UIImage(named: "chat") ,tag:4)
    
    UITabBar.appearance().barTintColor = .clear
    
    let controllers = [feedVC, menuVC, searchVC, messagesVC]
    tabBarController.viewControllers = controllers
    
    window?.rootViewController = tabBarController
    self.window?.makeKeyAndVisible()
  }


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    FirebaseApp.configure()
    checkIfUserIsLogedIn()

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

