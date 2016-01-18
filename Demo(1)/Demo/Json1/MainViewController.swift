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
    var TextFieldSearchBar: UITextField!
    var ViewSearch: UIView!
    @IBOutlet weak var ButtonSearch: UIButton!
    //定位按钮
    @IBOutlet weak var ButtonLocation: UIButton!
    var address:String?
    
    //商品model
    var item: GoodDetail?
    
    override func viewDidLoad() {
        self.hidesBottomBarWhenPushed = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "viewDidLoad", name: "reloadMainView", object: nil)
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        if(userDefault.boolForKey("needSetLocation") == false){
            self.performSegueWithIdentifier("showLocation", sender: nil)
        }else{
            initAll()
        }
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
        var vc = segue.destinationViewController
        if( vc.isKindOfClass(OtherViewController)){
            let vc2 = vc as! OtherViewController
            vc2.item = self.item
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
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
        initViewSearch()
        
    }
    
    func initViewSearch(){
        
        ViewSearch = UIView(frame: CGRect(x: 0, y:-40, width: self.view.frame.width, height: 40))
        ViewSearch.backgroundColor = UIColor.colorWith(245, green: 77, blue: 86, alpha: 1)
        webView?.scrollView.addSubview(ViewSearch)
        
        TextFieldSearchBar = UITextField()
        TextFieldSearchBar.backgroundColor = UIColor.whiteColor()
        TextFieldSearchBar.placeholder = "输入便利店或商品名称"
        TextFieldSearchBar.layer.cornerRadius = 4
        TextFieldSearchBar.textAlignment = .Center
        ViewSearch.addSubview(TextFieldSearchBar)
        TextFieldSearchBar.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(ViewSearch)
            make.left.equalTo(ViewSearch).offset(20)
            make.height.equalTo(26)
        }
        TextFieldSearchBar.delegate = self
    }
    
    func initHttpManager(){
        httpManager.responseSerializer = AFJSONResponseSerializer()
        httpManager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        httpManager.requestSerializer = AFJSONRequestSerializer()
    }
    
    func initWebView(){
        let url = "http://192.168.43.185:8080/BSMD/main.do"
        let config = WKWebViewConfiguration()
        config.userContentController.addScriptMessageHandler(self, name: "gan")
        webView = WKWebView(frame: CGRect(x: 0, y:49, width: self.view.frame.width, height: self.view.frame.height-58),configuration: config)
        webView?.scrollView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        webView?.scrollView.frame.size.width = self.view.frame.width
        webView?.scrollView.bounces = false
        webView?.scrollView.showsHorizontalScrollIndicator = false
        webView?.scrollView.showsVerticalScrollIndicator = false
        webView?.scrollView.delegate = self
        webView!.navigationDelegate = self
        
        self.address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
        
        
        httpManager.POST(url, parameters: ["address":self.address!,"page":"home","type":"Android"], success: { (opertaion, response) -> Void in
            let json = response as! NSDictionary
            self.index = json["index"] as! String
            self.content = json["txt"] as! NSDictionary
            self.webView?.loadRequest(NSURLRequest(URL: NSURL(string: self.index!)!))
            }) { (operation, error) -> Void in
                print(error)
        }
        
        //MARK:顺便更新地位按钮名称，显示当前的小区
        let str = address!.stringByReplacingOccurrencesOfString("-", withString: "")
        ButtonLocation.setTitle(str, forState: .Normal)
        
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
        //MARK:接收到点击了哪个商品
        httpManager.POST("http://192.168.43.185:8080/BSMD/item/detail.do", parameters: ["itemno":message.body,"address":address!], success: { (opreation, response) -> Void in
            print("wo shi response")
            print(response)
            let dict = response.objectForKey("detail") as! [String: AnyObject]
            print("wo shi dict")
            print(dict)
            self.item = GoodDetail()
            var arry = response.objectForKey("comment") as? NSArray
            
            self.item?.comments = [Comment]()
            for var x in arry!{
                var xx = x as! [String: AnyObject]
                self.item?.comments?.append(Comment(content: xx["comment"] as? String, date: xx["commentDate"] as? String, userName: xx["custNo"] as? String))
            }
            self.item?.barcode = dict["barcode"] as? String
            self.item?.eshopIntegral = dict["eshopIntegral"] as! Int
            self.item?.itemBynum1 = dict["itemBynum1"] as! String
            self.item?.itemName = dict["itemName"] as! String
            self.item?.itemNo = dict["itemNo"] as! String
            self.item?.itemSalePrice = dict["itemSalePrice"] as! String
            arry = response.objectForKey("stocks") as! NSArray
            print(arry)
            self.item?.itemStocks = [ItemStock]()
            for var x in arry!{
                var xx = x as! [String: AnyObject]
                self.item?.itemStocks.append(ItemStock(name: xx["shopName"] as? String, qty: xx["stockQty"] as? Int))
            }
            
            arry = dict["itemUnits"] as! NSArray
            print(arry)
            self.item?.itemUnits = [ItemUnit]()
            for var x in arry!{
                var xx = x as! [String: AnyObject]
                self.item?.itemUnits.append(ItemUnit(salePrice: xx["itemSalePrice"] as? String , sizeName: xx["itemSize"] as? String))
            }
            
            self.item?.imageDetail = response.objectForKey("imageDetail") as! [String]
            self.item?.imageTop = response.objectForKey("imageTop") as! [String]
            self.performSegueWithIdentifier("showHome", sender: self)
            }) { (opreation,error) -> Void in
                print(error)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        let y = scrollView.contentOffset.y > 0 ? 0: scrollView.contentOffset.y
        if( y != 0){
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
        textField.resignFirstResponder()
        self.navigationController?.navigationBarHidden = false
        self.performSegueWithIdentifier("showSearcher", sender: nil)

    }
}











