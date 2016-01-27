//
//  ResignViewController.swift
//  Demo
//
//  Created by mac on 15/12/17.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class ResignViewController: UIViewController,UIScrollViewDelegate {
    
    var topView: UIView!
    var backScrollView: UIScrollView!
    var phoneTextField: UITextField!
    var psdTextField: UITextField!
    var rePsdTextField: UITextField!
    var resignButton: UIButton!
    override func viewDidLoad() {
        addScrollView()
        addTextField()
        addResignButton()
    }
    
    func addScrollView() {
        backScrollView = UIScrollView(frame: view.bounds)
        backScrollView.backgroundColor = UIColor.colorWith(245, green: 245, blue: 245, alpha: 1)
        backScrollView.alwaysBounceVertical = true
        let tap = UITapGestureRecognizer(target: self, action: "backScrollViewTap")
        backScrollView.addGestureRecognizer(tap)
        view.addSubview(backScrollView)
    }

    func addTextField() {
        let textH: CGFloat = 40
        let leftDistance: CGFloat = 20
        let leftMargin: CGFloat = 10
        let alphaV: CGFloat = 0.2
        topView = UIView(frame: CGRectMake(0, 20, AppWidth, textH * 3))
        topView?.backgroundColor = UIColor.whiteColor()
        backScrollView.addSubview(topView!)
        
        let line1 = UIView(frame: CGRectMake(0, 0, AppWidth, 1))
        line1.backgroundColor = UIColor.grayColor()
        line1.alpha = alphaV
        topView!.addSubview(line1)
        
        phoneTextField = UITextField()
        phoneTextField?.keyboardType = UIKeyboardType.NumberPad
        addTextFieldToTopViewWiht(phoneTextField!, frame: CGRectMake(leftDistance, 1, AppWidth - leftMargin * 2, textH - 1), placeholder: "请输入手机号")
        
        let line2 = UIView(frame: CGRectMake(leftDistance, textH, AppWidth, 1))
        line2.backgroundColor = UIColor.grayColor()
        line2.alpha = alphaV
        topView!.addSubview(line2)
        
        psdTextField = UITextField()
        psdTextField.secureTextEntry = true
        addTextFieldToTopViewWiht(psdTextField!, frame: CGRectMake(leftDistance, textH + 1, AppWidth - leftMargin * 2, textH - 1), placeholder: "请输入密码")
        
        let line3 = UIView(frame: CGRectMake(leftDistance, textH * 2, AppWidth, 1))
        line3.backgroundColor = UIColor.grayColor()
        line3.alpha = alphaV
        topView!.addSubview(line3)
        
        rePsdTextField = UITextField()
        rePsdTextField.secureTextEntry = true
        addTextFieldToTopViewWiht(rePsdTextField!, frame: CGRectMake(leftDistance, textH * 2 + 1, AppWidth - leftMargin * 2, textH - 1), placeholder: "请再次输入密码")
    }
    
    func addResignButton() {
        resignButton = UIButton(frame: CGRect(x: 30, y: 160, width: AppWidth - 2 * 30, height: 35))
        resignButton.backgroundColor = UIColor.colorWith(90, green: 193, blue: 223, alpha: 1)
        resignButton.setTitle("发送验证码", forState: UIControlState.Normal)
        resignButton.tintColor = UIColor.whiteColor()
        resignButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        resignButton.layer.cornerRadius = 3
        resignButton.addTarget(self, action: "sentCodeClick", forControlEvents: UIControlEvents.TouchUpInside)
        backScrollView.addSubview(resignButton)
    }
    
    func addTextFieldToTopViewWiht(textField: UITextField ,frame: CGRect, placeholder: String) {
        textField.frame = frame
        textField.autocorrectionType = .No
        textField.clearButtonMode = .Always
        textField.backgroundColor = UIColor.whiteColor()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFontOfSize(14)
        topView!.addSubview(textField)
    }
    
    func backScrollViewTap() {
        view.endEditing(true)
    }
}

extension ResignViewController {
    func sentCodeClick() {
        
        if !phoneTextField.text!.validateMobile() {
            SVProgressHUD.showErrorWithStatus("请输入11位的正确手机号", maskType: SVProgressHUDMaskType.Black)
            return
        } else if
            psdTextField.text!.isEmpty {
                SVProgressHUD.showErrorWithStatus("密码不能为空", maskType: SVProgressHUDMaskType.Black)
                return
        }
        else if psdTextField.text != rePsdTextField.text {
            SVProgressHUD.showErrorWithStatus("两次输入密码不一致", maskType: SVProgressHUDMaskType.Black)
            return
        }
        
        let param: [String : AnyObject] = ["tel" : phoneTextField.text! , "password" : psdTextField.text! ]
        HTTPManager.POST(ContentType.ValidateAndSend, params: param).responseJSON({ (json) -> Void in
            print("注册界面发送验证码返回数据")
            print(json)
            let info = json as? NSDictionary
            let vc = SentSecurityCodeViewController()
            vc.phoneNumber = self.phoneTextField.text
            vc.password = self.psdTextField.text
            vc.codeNumber = info!["validateCode"] as? String
            self.navigationController?.pushViewController(vc, animated: true)
            }) { (error) -> Void in
                SVProgressHUD.showErrorWithStatus("发送验证码失败,请点击重试", maskType: SVProgressHUDMaskType.Black)
                
        }
    }
    @IBAction func closeResign(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
