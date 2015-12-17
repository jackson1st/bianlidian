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
    @IBOutlet var rePsdTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var sendBarcode: UIButton!
    
    override func viewDidLoad() {
        
    }
}
extension ResignViewController {
    func isError() {
        if(PhoneTextField.text == nil) {
            SVProgressHUD.showInfoWithStatus("手机号不能为空")
        }
    }
}
extension ResignViewController {
    @IBAction func resignAction(sender: AnyObject) {
        isError()
        SVProgressHUD.showInfoWithStatus("手机号不能为空")

//        NetworkManager.sharedManager.requestJSON(HTTPMethod.POST, "192.168.199.233:8080/BSMD/registerMobile.do", [String : String]?) { (result, error) -> () in
//            
//        }
        print("我注册了")
    }
}