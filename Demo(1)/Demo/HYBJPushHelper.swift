//
//  HYBJPushHelper.swift
//  Demo
//
//  Created by mac on 15/12/19.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import Foundation
import UIKit



var HYBJPushHelper: NSObject?


func setupWithOptions(launchOptions: NSDictionary) {
    JMessage.setupJMessage(launchOptions as [NSObject : AnyObject], appKey: JMSSAGE_APPKEY, channel: CHANNEL, apsForProduction: false, category: nil)
    // Required - 注册 APNs 通知
    JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue , categories: nil)
    JPUSHService.setupWithOption(launchOptions as [NSObject : AnyObject])
}

func registerDeviceToken(deviceToken: NSData) {
    JPUSHService.registerDeviceToken(deviceToken)
}
