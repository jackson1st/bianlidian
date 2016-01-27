//
//  SentSecurityCodeViewController.swift
//  Demo
//
//  Created by mac on 16/1/25.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit
class SentSecurityCodeViewController: UIViewController,UIScrollViewDelegate {
    
    var topView: UIView!
    var backScrollView: UIScrollView!
    var phoneTextField: UITextField!
    var codeTextField: UITextField!
    var resignButton: UIButton!
    var phoneNumber: String!
    var timerButton: UIButton!
    var timerLabel: UILabel!
    var codeNumber: String!
    var password: String!
    override func viewDidLoad() {
        addScrollView()
        addTextField()
        addResignButton()
        timeCount()
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
        topView = UIView(frame: CGRectMake(0, 20, AppWidth, textH * 2))
        topView?.backgroundColor = UIColor.whiteColor()
        backScrollView.addSubview(topView!)
        
        let line1 = UIView(frame: CGRectMake(0, 0, AppWidth, 1))
        line1.backgroundColor = UIColor.grayColor()
        line1.alpha = alphaV
        topView!.addSubview(line1)
        
        phoneTextField = UITextField()
        phoneTextField.userInteractionEnabled = false
        addTextFieldToTopViewWiht(phoneTextField!, frame: CGRectMake(leftDistance, 1, AppWidth - leftMargin * 4 , textH - 1), placeholder: "")
        phoneTextField.text = phoneNumber
        
        timerButton = UIButton(frame: CGRect(x: AppWidth - leftDistance * 4 - 10, y: 5, width: 80, height: textH - 10))
        timerButton.backgroundColor = UIColor.colorWith(245, green: 77, blue: 86, alpha: 1)
        timerButton.layer.cornerRadius = 4
        timerButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        timerButton.setTitle("发送验证码", forState: UIControlState.Normal)
        topView.addSubview(timerButton)
        
        let line2 = UIView(frame: CGRectMake(leftDistance, textH, AppWidth, 1))
        line2.backgroundColor = UIColor.grayColor()
        line2.alpha = alphaV
        topView!.addSubview(line2)
        
        codeTextField = UITextField()
        codeTextField.secureTextEntry = true
        addTextFieldToTopViewWiht(codeTextField!, frame: CGRectMake(leftDistance, textH + 1, AppWidth - leftMargin * 2, textH - 1), placeholder: "请输入验证码")
    }
    
    func addResignButton() {
        resignButton = UIButton(frame: CGRect(x: 30, y: 120, width: AppWidth - 2 * 30, height: 35))
        resignButton.backgroundColor = UIColor.colorWith(90, green: 193, blue: 223, alpha: 1)
        resignButton.setTitle("注册", forState: UIControlState.Normal)
        resignButton.tintColor = UIColor.whiteColor()
        resignButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        resignButton.layer.cornerRadius = 3
        resignButton.addTarget(self, action: "resignClick", forControlEvents: UIControlEvents.TouchUpInside)
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

extension SentSecurityCodeViewController : MZTimerLabelDelegate{
    func resignClick(){
        
        HTTPManager.POST(ContentType.Register, params: ["tel" : phoneNumber,"password": password]).responseJSON({ (json) -> Void in
            print("注册成功")
            }) { (error) -> Void in
                print(error)
        }
    }
    func timeCount() {
        timerButton.setTitle(nil, forState: UIControlState.Normal)
        timerButton.backgroundColor = UIColor.lightGrayColor()
        timerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80 , height: 30))
        timerButton.addSubview(timerLabel)
        var timer_cutDown = MZTimerLabel(label: timerLabel, andTimerType: MZTimerLabelTypeTimer)
        timer_cutDown.setCountDownTime(60)
        timer_cutDown.timeFormat = "倒计时 ss"
        timer_cutDown.timeLabel.textColor = UIColor.whiteColor()
        timer_cutDown.timeLabel.font = UIFont.systemFontOfSize(13)
        timer_cutDown.timeLabel.textAlignment = NSTextAlignment.Center
        timer_cutDown.delegate = self
        timerButton.userInteractionEnabled = false
        timer_cutDown.start()
    }
    //倒计时结束后的代理方法
    func timerLabel(timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: NSTimeInterval) {
        timerButton.setTitle("发送验证码", forState: UIControlState.Normal)
        timerButton.removeFromSuperview()
        timerButton.userInteractionEnabled = true
    }

}

