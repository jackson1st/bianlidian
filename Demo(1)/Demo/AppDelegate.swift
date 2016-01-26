//
//  AppDelegate.swift
//  Demo
//
//  Created by mac on 15/12/6.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit
import CoreData
let JMSSAGE_APPKEY = "8d549848e992adf575cb53ec"
let CHANNEL = ""
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Required - 初始化
        let bar = UINavigationBar.appearance()
        bar.barTintColor = UIColor.colorWith(242, green: 48, blue: 58, alpha: 1)
        bar.tintColor = UIColor.whiteColor()
        let navigationTitleAttribute: NSMutableDictionary = NSMutableDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        navigationTitleAttribute.setObject(UIFont.systemFontOfSize(17), forKey: NSFontAttributeName)
        bar.titleTextAttributes = navigationTitleAttribute as?[String: AnyObject]
        if (UIApplication.sharedApplication().currentUserNotificationSettings()?.types != UIUserNotificationType.None) {
//            self.addLocalNotification()
        }
        else {
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        }

//        JMessage.setupJMessage(launchOptions, appKey: JMSSAGE_APPKEY, channel: CHANNEL, apsForProduction: false, category: nil)
//         // Required - 注册 APNs 通知
//        JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue , categories: nil)
//       registerJPushStatusNotification()
        return true
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        deviceToken = String(format: "%s", arguments: deviceToken)
//        let color: UIColor = UIColor(red: 0.0 / 255, green: 122.0 / 255, blue: 255.0 / 255, alpha: 1)
         JPUSHService.registerDeviceToken(deviceToken)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func registerJPushStatusNotification () {
        
    let defaultCenter = NSNotificationCenter.defaultCenter()
    defaultCenter.addObserver(self, selector: "networkDidSetup:", name: kJPFNetworkDidSetupNotification, object: nil)
    defaultCenter.addObserver(self, selector: "networkIsConnecting:", name: kJPFNetworkIsConnectingNotification, object: nil)
    defaultCenter.addObserver(self, selector: "networkDidClose:", name: kJPFNetworkDidCloseNotification, object: nil)
    defaultCenter.addObserver(self, selector: "networkDidRegister:", name: kJPFNetworkDidRegisterNotification, object: nil)
    defaultCenter.addObserver(self, selector: "networkDidLogin:", name: kJPFNetworkDidLoginNotification, object: nil)
    defaultCenter.addObserver(self, selector: "receivePushMessage:", name: kJPFNetworkDidReceiveMessageNotification, object: nil)
    
    }
    // notification from JPush
    func networkDidSetup(notification: NSNotification ){

    }
    
    // notification from JPush
    func networkIsConnecting(notification: NSNotification ){
        
    }
    
    // notification from JPush
    func networkDidClose(notification: NSNotification ){
        
    }

    // notification from JPush
    func networkDidRegister(notification: NSNotification ){
        
    }
    // notification from JPush
    func networkDidLogin(notification: NSNotification ){
        
    }
    // notification from JPush
    func receivePushMessage(notification: NSNotification ){
        let userInfo = notification.userInfo
        let alert = UIAlertView(title: "收到推送消息", message: "\(userInfo!["aps"]!["alert"])", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        Model.defaultModel.uploadData()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.hrh.Demo" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Demo", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

