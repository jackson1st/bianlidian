//
//  MyCenterController.swift
//  Demo
//
//  Created by mac on 16/1/23.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class MyCenterController: UITableViewController {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var integral: UILabel!
    
    override func viewDidLoad() {
        
        
        if let data = NSData(contentsOfFile: SD_UserIconData_Path) {
            iconImageView.image = UIImage(data: data)!.imageClipOvalImage()
        } else {
            iconImageView.image = UIImage(named: "my")
        }
        
        if theme.userName == nil {
            
            userName.text = UserAccountTool.userAccount()
        }
        else {
            
            userName.text = theme.userName
        }
        
        phoneNumber.text = UserAccountTool.userAccount()
        
        
        
    }

}

extension MyCenterController {
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0 && indexPath.row == 0){
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "SignOut", object: self))
            let user = NSUserDefaults.standardUserDefaults()
            user.setObject(nil, forKey: SD_UserDefaults_Account)
            user.setObject(nil, forKey: SD_UserDefaults_Password)
            if user.synchronize() {
                navigationController!.popViewControllerAnimated(true)
            }
            do {
                // 将本地的icon图片data删除
                try NSFileManager.defaultManager().removeItemAtPath(SD_UserIconData_Path)
            } catch _ {
            }

        }
    }
}