//
//  SortViewController.swift
//  webDemo
//
//  Created by Jason on 15/11/8.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit
import WebKit
class SortViewController: UIViewController,WKNavigationDelegate{

    var webView: WKWebView?
    var TextFieldSearchBar: UITextField!
    var ViewSearch: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlrequest = NSURLRequest(URL: NSURL(string: "https://5.webfjnu.sinaapp.com/sort.html")!)
        webView = WKWebView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height-49))
        webView!.navigationDelegate = self
        webView!.loadRequest(urlrequest)
        self.view.addSubview(webView!)
        initViewSearch()
        //webView = WKWebView(frame: CGRect(x: 0, y: 64, width: <#T##Int#>, height: <#T##Int#>))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        var credential = NSURLCredential(trust: challenge.protectionSpace.serverTrust!)
        challenge.sender?.useCredential(credential, forAuthenticationChallenge: challenge)
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
    }
    
    func initViewSearch(){
        
        ViewSearch = UIView(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: 64))
        ViewSearch.backgroundColor = UIColor.colorWith(245, green: 77, blue: 86, alpha: 1)
        view.addSubview(ViewSearch)
        
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
       // TextFieldSearchBar.delegate = self
    }


    deinit{
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        print("清除缓存")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
