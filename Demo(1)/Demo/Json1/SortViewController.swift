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
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlrequest = NSURLRequest(URL: NSURL(string: "https://5.webfjnu.sinaapp.com/sort.html")!)
        webView = WKWebView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height-49))
        webView!.navigationDelegate = self
        webView!.loadRequest(urlrequest)
        self.view.addSubview(webView!)
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
