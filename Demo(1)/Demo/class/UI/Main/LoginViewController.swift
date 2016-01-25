//
//  LoginViewController.swift
//  SmallDay

//  登陆控制器

import UIKit

public let SD_UserLogin_Notification = "SD_UserLogin_Notification"
public let SD_UserDefaults_Account = "SD_UserDefaults_Account"
public let SD_UserDefaults_Password = "SD_UserDefaults_Password"

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
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let navigationTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as?[String: AnyObject]
        //添加scrollView
        addScrollView()
        
        addLoginButton()
        addForgetButton()
        // 添加手机文本框和密码文本框
        addTextField()
        // 添加键盘通知
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrameNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        forgetButton.tintColor = UIColor.blueColor()
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
//        lgoin(account!,passWord: psdMD5!)
//        //将用户的账号和密码暂时保存到本地,实际开发中光用MD5加密是不够的,需要多重加密
        NSUserDefaults.standardUserDefaults().setObject(account, forKey: SD_UserDefaults_Account)
        NSUserDefaults.standardUserDefaults().setObject(psdMD5, forKey: SD_UserDefaults_Password)
        if NSUserDefaults.standardUserDefaults().synchronize() {
            navigationController?.popViewControllerAnimated(true)
           }
        else{
            SVProgressHUD.showErrorWithStatus("登录失败，请检查账号密码", maskType: SVProgressHUDMaskType.Black)
        }
    
    }
    
    func forgetClick(){
        
    }
    
//    func keyboardWillChangeFrameNotification(note: NSNotification) {
//        // TODO 添加键盘弹出的事件
//        let userinfo = note.userInfo!
//        let rect = userinfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
//        var boardH = AppHeight - rect.origin.y
//        if boardH > 0 {
//            boardH = boardH + NavigationH
//        }
//        backScrollView.contentSize = CGSizeMake(0, view.height + boardH)
//    }
    
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
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        let parameters = ["username":userName,
            "password":passWord]
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //这里写需要大量时间的代码
            print("这里写需要大量时间的代码")
            dispatch_async(dispatch_get_main_queue(), {
                manager.POST("http://192.168.199.233:8080/BSMD/loginMobile.do", parameters: parameters, success: { (oper, data) -> Void in
                    if let Ok = data as? NSDictionary {
                        if(true) {
//                        if(Ok["status"] as! String == "success") {
                         //将用户的账号和密码暂时保存到本地,实际开发中光用MD5加密是不够的,需要多重加密
                                NSUserDefaults.standardUserDefaults().setObject(userName, forKey: SD_UserDefaults_Account)
                                NSUserDefaults.standardUserDefaults().setObject(passWord, forKey: SD_UserDefaults_Password)
                                if NSUserDefaults.standardUserDefaults().synchronize() {
                                    self.navigationController?.popViewControllerAnimated(true)
                            }
                            else{
                                SVProgressHUD.showErrorWithStatus("登录失败，请检查账号密码", maskType: SVProgressHUDMaskType.Black)
                            }
                            

                        }
                    }
                    }) { (opeation, error) -> Void in
                        print(error)
                }
            })
        })
    }
}