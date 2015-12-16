//
//  MainViewController.swift
//  webDemo
//
//  Created by jason on 15/11/7.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit
import WebKit

class MainViewController: UIViewController,WKNavigationDelegate,UISearchBarDelegate,UINavigationControllerDelegate,WKScriptMessageHandler,UITextFieldDelegate,UIScrollViewDelegate{
    
    //一些变量的定义
    @IBOutlet weak var navItem: UINavigationItem!
    var webView: WKWebView?
    var ConstraintWebViewY: NSLayoutConstraint?
    var nextURLRequest: NSURLRequest?
    var rightBarButton:UIBarButtonItem?
    var leftBarButton: UIBarButtonItem?
    //设置相关
    let httpManager = AFHTTPRequestOperationManager()
    let userDefault = NSUserDefaults()
    //网页初始化相关
    var index: String?
    var content: NSDictionary?
    
    //搜索相关
    @IBOutlet weak var TextFieldSearchBar: UITextField!
    
    @IBOutlet weak var ButtonSearch: UIButton!
    
    @IBOutlet weak var ViewSearch: UIView!
    @IBOutlet weak var ConstraintViewSearchY: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initAll()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
//MARK: - 页面跳转操作
extension MainViewController{
    //隐藏tabBar的方法：在跳转之前调用self.hidesBottomBarWhenPushed = true
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        self.hidesBottomBarWhenPushed = true
    }

    override func viewDidAppear(animated: Bool) {
//        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
//        self.tabBarController!.tabBar.hidden = false
//        
    }

    override func viewWillAppear(animated: Bool) {
        
        var userDefault = NSUserDefaults.standardUserDefaults()
        if(userDefault.boolForKey("needSetLocation") == false){
            self.performSegueWithIdentifier("showLocation", sender: nil)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

//MARK: - 一些初始化操作
extension MainViewController{
    
    func initAll(){
        initHttpManager()
        initWebView()
    }
    
    func initHttpManager(){
        httpManager.responseSerializer = AFJSONResponseSerializer()
        httpManager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        httpManager.requestSerializer = AFJSONRequestSerializer()
    }
    
    func initWebView(){
        let url = "http://192.168.199.242:8080/BSMD/main.do"
        let config = WKWebViewConfiguration()
        config.userContentController.addScriptMessageHandler(self, name: "gan")
        webView = WKWebView(frame: CGRect(x: 0, y:89, width: self.view.frame.width, height: self.view.frame.height-138),configuration: config)
        webView?.scrollView.bounces = false
        webView?.scrollView.showsHorizontalScrollIndicator = false
        webView?.scrollView.showsVerticalScrollIndicator = false
        webView?.scrollView.delegate = self
        webView!.navigationDelegate = self
        
        let address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
        
        httpManager.POST(url, parameters: ["address":address,"page":"home","type":"Android"], success: { (opertaion, response) -> Void in
            let json = response as! NSDictionary
            self.index = json["index"] as! String
            self.content = json["txt"] as! NSDictionary
            self.webView?.loadRequest(NSURLRequest(URL: NSURL(string: self.index!)!))
            }) { (operation, error) -> Void in
                print(error)
        }
        self.view.addSubview(webView!)
    }
    
}


//MARK:- WebView一些操作
extension MainViewController{
    
    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        var credential = NSURLCredential(trust: challenge.protectionSpace.serverTrust!)
        challenge.sender?.useCredential(credential, forAuthenticationChallenge: challenge)
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        print("我要跳转了！")
        var url = navigationAction.request.URL
        print(url!.absoluteString)
        if(url!.absoluteString != index){
            decisionHandler(WKNavigationActionPolicy.Cancel)
            nextURLRequest = navigationAction.request
            self.performSegueWithIdentifier("showHome", sender: self)
        }else{
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        let data = try? NSJSONSerialization.dataWithJSONObject(self.content!, options: NSJSONWritingOptions())
        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //str = str?.stringByReplacingOccurrencesOfString("/", withString: "")
        //            str = str?.stringByReplacingOccurrencesOfString("\"", withString: "")
        //print(str)
        let str1 = "'" + (str as! String) + "'"
        let tag = "'iPhone'"
        self.webView?.evaluateJavaScript("load(\(str1),'iPhone')", completionHandler: { (response,error) -> Void in
            print(response)
            print(error)
        })
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        //接收到点击了哪个商品
        print(message.body)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let y = scrollView.contentOffset.y > 40 ? 40: scrollView.contentOffset.y
        ConstraintViewSearchY.constant = -y
        webView?.frame = CGRect(x: 0, y: 89 - y, width: webView!.frame.width, height: self.view.frame.size.height - 89 + y)
        print(ConstraintWebViewY)
        if( y != 40){
            if(ButtonSearch.hidden == false){
                ButtonSearch.hidden = true
            }
        }else{
            if(ButtonSearch.hidden == true){
                ButtonSearch.hidden = false
            }
        }
    }

}

//MARK:-一些控件的方法
extension MainViewController{
    
    @IBAction func ButtonLocationClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("showLocation", sender: nil)
    }
    
    @IBAction func ButtonSearchClicked(sender: AnyObject) {
        textFieldDidBeginEditing(TextFieldSearchBar)
    }
    
    
    @IBAction func Clicked(){
        let alerVC = UIAlertController(title: "是否拨打电话", message: "拨打服务电话:15260025228", preferredStyle: UIAlertControllerStyle.Alert)
        alerVC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (AlertAction) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: "tel:15260025228")!)
        }))
        alerVC.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(alerVC, animated: true, completion: nil)
    }

}

//MARK:- TextField's delegate
extension MainViewController{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.navigationController?.navigationBarHidden = false
        self.performSegueWithIdentifier("showSearcher", sender: nil)
        textField.resignFirstResponder()
    }
}











