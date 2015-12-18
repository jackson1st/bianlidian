//
//  ResignViewController.swift
//  Demo
//
//  Created by mac on 15/12/17.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class ResignViewController: UIViewController {
    
    @IBOutlet var PhoneTextField: UITextField!
    @IBOutlet var barcodeTextField: UITextField!
    @IBOutlet var psdTexField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var sendBarcode: UIButton!
    
    override func viewDidLoad() {
        //发送验证码按钮一开始为不可点击
        sendBarcode.enabled = false
        sendBarcode.alpha = 0.6
        sendBarcode.layer.cornerRadius = 10.0
        PhoneTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
}
extension ResignViewController {
    
    /**
     检测正在输入
     
     - parameter textField: textField description
     */

    func textFieldDidChange(textField: UITextField){
        //判断状态OK 恢复发送验证码按钮点击事件
        if (PhoneTextField.text!.validateMobile()) {
            sendBarcode.enabled = true
            sendBarcode.alpha = 1
        }
        else {
            sendBarcode.enabled = false
            sendBarcode.alpha = 0.6
        }
        
    }

}
extension ResignViewController {
    @IBAction func resignAction(sender: AnyObject) {
        SVProgressHUD.showInfoWithStatus("手机号不能为空")
       
//        NetworkManager.sharedManager.requestJSON(HTTPMethod.POST, "192.168.199.233:8080/BSMD/registerMobile.do", [String : String]?) { (result, error) -> () in
//            
//        }
        print("我注册了")
    }
}