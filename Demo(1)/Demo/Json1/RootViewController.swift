//
//  RootViewController.swift
//  webDemo
//
//  Created by jason on 15/11/9.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit
class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.translucent = false
        changeCarNum()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doSomething", name: "finishAOrder", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeCarNum", name: "CarNumChanged", object: nil)
    }
    
    func changeCarNum(){
        if(Model.defaultModel.shopCart.count == 0) {
            self.tabBar.items![2].badgeValue = nil
        }
        else {
            self.tabBar.items![2].badgeValue = "\(Model.defaultModel.shopCart.count)"
        }
    }
    
    func doSomething(){
        
        selectedIndex = 3
        let workingQueue = dispatch_queue_create("queue", nil)
        dispatch_async(workingQueue) {
            NSThread.sleepForTimeInterval(0.5)
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("finishAOrder2", object: nil)
            })
        }
    }
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(animated: Bool) {
    }
    
    class func showTabBar(show: Bool){
        if(show){
        }
    }
    

}
