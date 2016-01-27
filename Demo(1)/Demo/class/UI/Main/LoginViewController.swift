//
//  LoginViewController.swift
//  SmallDay

//  登陆控制器

import UIKit

public let SD_UserLogin_Notification = "SD_UserLogin_Notification"
public let SD_UserDefaults_Account = "SD_UserDefaults_Account"
public let SD_UserDefaults_Password = "SD_UserDefaults_Password"
public let SD_UserDefaults_CustNo = "SD_UserDefaults_CustNo"
public let SD_UserDefaults_ImageUrl = "SD_UserDefaults_ImageUrl"
public let SD_UserDefaults_Integral = "SD_UserDefaults_Integral"
public let SD_UserDefaults_UserName = "SD_UserDefaults_UserName"

class LoginViewController: UIViewController, UIScrollViewDelegate {
    
    var backScrollView: UIScrollView!
    var topView: UIView!
    var phoneTextField: UITextField!
    var psdTextField: UITextField!
    var loginButton: UIButton!
    var forgetButton: UIButton!
    let textCoclor: UIColor = UIColor.colorWith(50, green: 50, blue: 50, alpha: 1)
    let loginW: CGFloat = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "登录"
        //添加scrollView
        addScrollView()
        
        addLoginButton()
        addForgetButton()
        // 添加手机文本框和密码文本框
        addTextField()
    }
    
    func setNavigation() {

    }
    func addScrollView() {
        backScrollView = UIScrollView(frame: view.bounds)
        backScrollView.backgroundColor = UIColor.colorWith(245, green: 245, blue: 245, alpha: 1)
        backScrollView.alwaysBounceVertical = true
        let tap = UITapGestureRecognizer(target: self, action: "backScrollViewTap")
        backScrollView.addGestureRecognizer(tap)
        view.addSubview(backScrollView)
    }
    
    func addLoginButton() {
        loginButton = UIButton(frame: CGRect(x: 30, y: 120, width: AppWidth - 2 * 30, height: 35))
        loginButton.backgroundColor = UIColor.colorWith(90, green: 193, blue: 223, alpha: 1)
        loginButton.setTitle("登录", forState: UIControlState.Normal)
        loginButton.tintColor = UIColor.whiteColor()
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        loginButton.layer.cornerRadius = 3
        loginButton.addTarget(self, action: "loginClick", forControlEvents: UIControlEvents.TouchUpInside)
        backScrollView.addSubview(loginButton)
    }
    
    func addForgetButton() {
        forgetButton = UIButton(frame: CGRect(x: 30, y: 175, width: 65, height: 30))
        forgetButton.setTitle("忘记密码?", forState: UIControlState.Normal)
        forgetButton.tintColor = UIColor.redColor()
        forgetButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        forgetButton.addTarget(self, action: "forgetClick", forControlEvents: UIControlEvents.TouchUpInside)
        backScrollView.addSubview(forgetButton)
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
        phoneTextField?.keyboardType = UIKeyboardType.NumberPad
        addTextFieldToTopViewWiht(phoneTextField!, frame: CGRectMake(leftDistance, 1, AppWidth - leftMargin * 2, textH - 1), placeholder: "请输入手机号")
        
        let line2 = UIView(frame: CGRectMake(0, textH, AppWidth, 1))
        line2.backgroundColor = UIColor.grayColor()
        line2.alpha = alphaV
        topView!.addSubview(line2)
        
        psdTextField = UITextField()
        psdTextField.secureTextEntry = true
        addTextFieldToTopViewWiht(psdTextField!, frame: CGRectMake(leftDistance, textH + 1, AppWidth - leftMargin * 2, textH - 1), placeholder: "密码")
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
    
    

    
    /// 登录按钮被点击
    func loginClick() {
        
         NSNotificationCenter.defaultCenter().postNotificationName("Login", object: self)
        if !phoneTextField.text!.validateMobile() {
            SVProgressHUD.showErrorWithStatus("请输入11位的正确手机号", maskType: SVProgressHUDMaskType.Black)
            return
        } else if
            psdTextField.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("密码不能为空", maskType: SVProgressHUDMaskType.Black)
            return
        }
        let account = phoneTextField.text
        let psdMD5 = psdTextField.text
        lgoin(account!,passWord: psdMD5!)
    }
    
    @IBAction func closeLogin(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func forgetClick(){
        
    }

    func backScrollViewTap() {
        view.endEditing(true)
    }
}
extension  LoginViewController {
    @IBAction func resignClick(sender: AnyObject) {
        
        let vc = ResignViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func lgoin(userName: String,passWord: String) {
        
        let parameters = ["username":userName,
            "password":passWord]
        MBProgressHUD.showMessage("登录中....")
        HTTPManager.POST(ContentType.LoginMobile, params: parameters).responseJSON({ (json) -> Void in
            print(json)
            
            let infomation = json as? NSDictionary

            if(infomation!["status"] as? String == "error") {
                 SVProgressHUD.showErrorWithStatus("登录失败，请检查账号密码", maskType: SVProgressHUDMaskType.Black)
                 MBProgressHUD.hideHUD()
                return
            }
            if(infomation!["status"] as? String == "success") {
                
                let custNo = infomation!["custNo"] as? String
                let userName = infomation!["userName"] as? String
                let imageUrl = infomation!["imageUrl"] as? String
                let integral = infomation!["integral"] as? Int
                UserAccountTool.setUserInfo(userName!, passWord: passWord, custNo: custNo!, userName: userName!, imageUrl: imageUrl!, integral: integral!)
                MBProgressHUD.hideHUD()
                return
            }
            
            }) { (error) -> Void in
              SVProgressHUD.showErrorWithStatus("登录失败，请检查账号密码", maskType: SVProgressHUDMaskType.Black)
               MBProgressHUD.hideHUD()
        }
    }
}