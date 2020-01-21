//
//  AppDelegate.swift
//  Find Love
//
//  Created by Kaiserdem on 24.12.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

extension UIApplication {
  var statusBarView: UIView? {
    if responds(to: Selector(("statusBar"))) {
      return value(forKey: "statusBar") as? UIView
    }
    return nil
  }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  let readIdentifier = "readIdentifier"
  let deleteIdentifier = "deleteIdentifier"
  let actionCategoryIndentifier = "categoryIndentifier"
  
  
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
  
  // регистирируем нотификацию с таким токеном
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
    let  tokenParts = deviceToken.map { data -> String in
      return String(format: "%02.2hhx", data)
    }
    let token = tokenParts.joined()
    print("Device Token: \(token)")
  }
  
  // если ошибка регистрации нотификации
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Fataled to register push notifications")
  }
  
  func registerForPushNotifications() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { [weak self] (isRegistered, error) in
      guard let strongSelf = self else { return }
      if let error = error {
        print("Error: \(error.localizedDescription)")
      }
      // создали екшены
      let actionRaed = UNNotificationAction(identifier: self!.readIdentifier, title: "Read", options: [.foreground])
      
      let actionDelete = UNNotificationAction(identifier: self!.deleteIdentifier, title: "Delete", options: [.destructive])
      // обьеденили в категорию
      let category = UNNotificationCategory(identifier: self!.actionCategoryIndentifier, actions: [actionRaed, actionDelete], intentIdentifiers: [], options: [])
      
       UNUserNotificationCenter.current().setNotificationCategories([category])
      
      strongSelf.getPushNotificationsConfigurarion()
    }
  }
  
  // получить настройки
  func getPushNotificationsConfigurarion() {
    
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      guard settings.authorizationStatus == .authorized else { return }
      // если автоизованы тогда регистрируем приложение
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
      
    }
  }
  
  // если приложение было активно в бекграунде, сработает этот метод
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    let dataInfo = userInfo as! [String: Any]
    print("Data: \(dataInfo["aps"])")
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    FirebaseApp.configure()
    checkIfUserIsLogedIn()
    registerForPushNotifications()
    
    if let option = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any], let data = option["aps"] {
      print("data: \(data)")
    }
        
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

