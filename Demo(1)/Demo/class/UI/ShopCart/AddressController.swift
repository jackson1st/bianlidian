//
//  AddressController.swift
//  Demo
//
//  Created by mac on 15/12/11.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

protocol OkDelegate: NSObjectProtocol {
    func returnOk(ok: String)
}
class AddressController: UITableViewController {
    @IBOutlet var name: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var tele: UITextField!
    var ad: [String] = []
     var delegate: OkDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        
    }
    func setNv() {
        navigationItem.title = "地址信息"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "didTappedBackButton")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确认", style: UIBarButtonItemStyle.Plain, target: self, action: "didTappedAddButton")
    }
// MARK: - 准备UI
    func prepareUI(){
        setNv()
        if (UserAddress.userIsAddress()) {
        ad = UserAddress.userAccount()!
        if(ad.count > 0) {
            name.text = ad[0]
            address.text = ad[1]
            tele.text = ad[2]
        }
        }
    }
}

// MARK: - 处理View上的响应事件
extension AddressController {
    func didTappedBackButton() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    func didTappedAddButton() {
        NSUserDefaults.standardUserDefaults().setObject(name.text, forKey: SD_UserDefaults_Name)
        NSUserDefaults.standardUserDefaults().setObject(tele.text, forKey: SD_UserDefaults_Telephone)
        NSUserDefaults.standardUserDefaults().setObject(address.text, forKey: SD_UserDefaults_Address)
        delegate?.returnOk("true")
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}