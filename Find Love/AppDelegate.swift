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
import FirebaseInstanceID
import FirebaseMessaging
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, GIDSignInDelegate {
  
  var window: UIWindow?
  
  let readIdentifier = "readIdentifier"
  let deleteIdentifier = "deleteIdentifier"
  let actionCategoryIndentifier = "categoryIndentifier"
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    FirebaseApp.configure()
    
    GIDSignIn.sharedInstance()?.clientID = "1049488869623-jqk9l162d6bhaefqn1s32qbbtb8frh19.apps.googleusercontent.com"
    GIDSignIn.sharedInstance()?.delegate = self
    
    registerForPushNotifications()
    //AuthManager.shared.handleLogout()
    AuthManager.shared.checkIfUserIsLogedIn()
    
    return true
  }
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    if error != nil {
      print(error.localizedDescription)
    } else {
      print("User Email:\(user.profile.email ?? "No Email")")
    }
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance().handle(url)
  }
  
  // MARK: - Push Notificarion
  
  // регистирируем нотификацию с таким токеном
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
    let  tokenParts = deviceToken.map { data -> String in
      return String(format: "%02.2hhx", data)
    }
    let token = tokenParts.joined()
   // print("Device Token: \(token)")
  }
  
  // если ошибка регистрации нотификации
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Fataled to register push notifications")
  }
  
  // приложение получило удаленное сообщение
  func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
    //print(remoteMessage.appData)
  }
  
  // если приложение было активно в бекграунде, сработает этот метод
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    let dataInfo = userInfo as! [String: Any]
  //  print("Data: \(String(describing: dataInfo["aps"]))")
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
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
  {
    completionHandler([.alert, .badge, .sound])
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
  

  func applicationWillResignActive(_ application: UIApplication) {
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    //reloadOnlineStatus(isOnline: false)
    AuthManager.shared.reloadOnlineStatus(isOnline: false)
  }
  
  // MARK: - Auth
  
//  func checkIfUserIsLogedIn() { // проверка если пользователь вошел в систему
//    if Auth.auth().currentUser?.uid == nil { // если мы не вошли
//      loadHelloVC()
//    } else {
//      loadFeedVC()
//      reloadOnlineStatus(isOnline: true)
//    }
//  }
//
//  func reloadOnlineStatus(isOnline online: Bool) {
//    guard let uid = Auth.auth().currentUser?.uid else { return }
//
//    let ref = Database.database().reference().child("users").child(uid)
//
//    if online == true {
//      let valuesStatus = ["statusOnline": "1"] as [String : Any]
//      ref.updateChildValues(valuesStatus)
//    } else {
//      let valuesStatus = ["statusOnline": "0"] as [String : Any]
//      ref.updateChildValues(valuesStatus)
//    }
//  }
//
//  func loadHelloVC() {
//    let nav1 = UINavigationController()
//    let mainView = HelloVC(nibName: "HelloVC", bundle: nil)
//    nav1.viewControllers = [mainView]
//    self.window!.rootViewController = nav1
//    self.window?.makeKeyAndVisible()
//  }
//
//  func loadFeedVC() {
//    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "CustomTabBar") as UIViewController
//    self.window = UIWindow(frame: UIScreen.main.bounds)
//    self.window?.rootViewController = initialViewControlleripad
//    self.window?.makeKeyAndVisible()
//  }
  
}

//extension UIApplication {
//  var statusBarView: UIView? {
//    if responds(to: Selector(("statusBar"))) {
//      return value(forKey: "statusBar") as? UIView
//    }
//    return nil
//  }
//}
