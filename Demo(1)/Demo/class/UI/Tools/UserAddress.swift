//
//  UserAddress.swift
//  Demo
//
//  Created by mac on 15/12/11.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class UserAddress: NSObject {
    class func userIsAddress() -> Bool {
        let user = NSUserDefaults.standardUserDefaults()
        let telephone = user.objectForKey(SD_UserDefaults_Telephone) as? String
        let address = user.objectForKey(SD_UserDefaults_Address) as? String
        let name = user.objectForKey(SD_UserDefaults_Name) as? String
        if telephone != nil && address != nil && name != nil{
            if !telephone!.isEmpty && !address!.isEmpty && !name!.isEmpty{
                return true
            }
        }
        return false
    }
    class func userAccount() -> [String]? {
        if !userIsAddress() {
            return nil
        }
        var information: [String] = []
        let user = NSUserDefaults.standardUserDefaults()
        let name = user.objectForKey(SD_UserDefaults_Name) as? String
        information.append(name!)
        let telephone = user.objectForKey(SD_UserDefaults_Telephone) as? String
        information.append(telephone!)
        let address = user.objectForKey(SD_UserDefaults_Address) as? String
        information.append(address!)
        return information
    }
}
 