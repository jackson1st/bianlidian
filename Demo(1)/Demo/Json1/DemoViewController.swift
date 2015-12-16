//
//  DemoViewController.swift
//  webDemo
//
//  Created by jason on 15/11/15.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let session = NSURLSession.sharedSession()
            let request = NSURLRequest(URL: NSURL(string: "http://5.webfjnu.sinaapp.com/image/panda1.jpg")!)
            let dataTask = session.dataTaskWithRequest(request, completionHandler: {
                (data,response,error)->Void in
                var imgView = UIImageView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 300))
                imgView.image = UIImage(data: data!)
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    ()->Void in
                    self.view.addSubview(imgView)
                    self.view.setNeedsLayout()})
            })
            dataTask.resume()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
