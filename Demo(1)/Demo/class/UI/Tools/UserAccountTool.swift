//
//  UserAccountTool.swift
//  Demo
//
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.
//
//  管理用户账号工具

import UIKit

class UserAccountTool: NSObject {
   
    /// 判断当前用户是否登录
    class func userIsLogin() -> Bool {
        let user = NSUserDefaults.standardUserDefaults()
        let account = user.objectForKey(SD_UserDefaults_Account) as? String
        let password = user.objectForKey(SD_UserDefaults_Password) as? String
        
        if account != nil && password != nil {
            if !account!.isEmpty && !password!.isEmpty {
                return true
            }
        }
        return false
    }
    
    class func setUserInfo(phoneNomber: String,passWord: String, custNo: String,userName: String, imageUrl: String, integral: Int) {
        NSUserDefaults.standardUserDefaults().setObject(phoneNomber, forKey: SD_UserDefaults_Account)
        NSUserDefaults.standardUserDefaults().setObject(passWord, forKey: SD_UserDefaults_Password)
        NSUserDefaults.standardUserDefaults().setObject(custNo, forKey: SD_UserDefaults_CustNo)
        NSUserDefaults.standardUserDefaults().setObject(userName, forKey: SD_UserDefaults_UserName)
        NSUserDefaults.standardUserDefaults().setObject(imageUrl, forKey: SD_UserDefaults_ImageUrl)
        NSUserDefaults.standardUserDefaults().setObject(integral, forKey: SD_UserDefaults_Integral)
    }
    
    /// 如果用户登录了,返回用户的账号(电话号)
    class func userAccount() -> String? {
        if !userIsLogin() {
            return nil
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let account = user.objectForKey(SD_UserDefaults_Account) as? String
        return account!
    }
    class func userCustNo() -> String? {
        if !userIsLogin() {
            return nil
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let account = user.objectForKey(SD_UserDefaults_CustNo) as? String
        return account!
    }
    class func userName() -> String? {
        if !userIsLogin() {
            return nil
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let account = user.objectForKey(SD_UserDefaults_UserName) as? String
        return account!
    }
    class func userIntegral() -> Int? {
        if !userIsLogin() {
            return nil
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let account = user.objectForKey(SD_UserDefaults_Integral) as? Int
        return account!
    }
    class func userImageUrl() -> String? {
        if !userIsLogin() {
            return nil
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let account = user.objectForKey(SD_UserDefaults_ImageUrl) as? String
        return account!
    }
    
}

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

class UserOrderInfo: NSObject {
    class func isNote() -> Bool{
        let info = NSUserDefaults.standardUserDefaults()
        let note = info.objectForKey(SD_OrderInfo_Note)
        if note != nil {
            return true
        }
        return false
    }
    class func orderInfoNote() -> String? {
        if !isNote() {
            return nil
        }
        let info = NSUserDefaults.standardUserDefaults()
        let note = info.objectForKey(SD_OrderInfo_Note) as? String
        return note
    }
}

