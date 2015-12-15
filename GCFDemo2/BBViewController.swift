//
//  BBViewController.swift
//  GCFDemo2
//
//  Created by jason on 15/10/29.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit

class BBViewController: UIViewController,MBProgressHUDDelegate,NSURLSessionTaskDelegate{

    @IBOutlet weak var finishedFlag: UILabel!
    @IBOutlet weak var URLText: UITextField!
    var semaphore = dispatch_semaphore_create(0)
    var mbp: MBProgressHUD?
    var GG: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        GG = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("GG", ofType: "plist")!) as! Array
        mbp = MBProgressHUD()
        mbp!.labelText = "正在努力工作"
        //mbp!.dimBackground = true
        mbp!.delegate = self
        self.view.addSubview(mbp!)
        
        // Do any additional setup after loading the view.
    }
    
    func hudWasHidden(hud: MBProgressHUD!) {
        mbp!.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func baButtonClicked() {
        mbp!.showWhileExecuting("dosomething", onTarget: self, withObject: nil, animated: true)
        //MBProgressHUD.showSuccess("操作完成")
    }
    func dosomething(){
        var url = URLText.text
        var urlRequest = NSURLRequest(URL: NSURL(string: url!)!)
        var session = NSURLSession.sharedSession()
        let sp = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
        let insp = "\(sp[0])/in.txt"
        let ousp = "\(sp[0])/out.txt"
        let ousp2 = "\(sp[0])/out2.txt"
        let sourcesp = "\(sp[0])/data.txt"
       // URLText.text = insp
        var mbp = MBProgressHUD()
        var fileManager = NSFileManager.defaultManager()
        fileManager.createFileAtPath(insp, contents: nil, attributes: nil)
        fileManager.createFileAtPath(ousp, contents: nil, attributes: nil)
        fileManager.createFileAtPath(sourcesp, contents: nil, attributes: nil)
        fileManager.createFileAtPath(ousp2, contents: nil, attributes: nil)
        var inarray = String()
        var ouarray = String()
        var ouarray2 = String()
        
        //print(filesp)
        var task = session.dataTaskWithRequest(urlRequest, completionHandler: {
            (data, response, error) -> Void in
            if(data != nil) {
                //                    var str = NSString(data: data!, encoding:NSUTF8StringEncoding )
                //                    print(str)
                var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //                    do{
                //                        try str?.writeToFile(sourcesp, atomically: true, encoding: NSUTF8StringEncoding)
                //                    }catch{
                //                        print("1")
                //                    }
                var xpathParser = TFHpple(HTMLData: data)
                var dataArry = NSArray(array: xpathParser.searchWithXPathQuery("//pre"))
                do{
                    try dataArry[0].content!.writeToFile(sourcesp, atomically: true, encoding: NSUTF8StringEncoding)
                }catch{
                    print("Error")
                }
                for var i = 1 ; i<dataArry.count;i+=4 {
                    //print(hppleElement.raw)
                    if(dataArry[i].content!.containsString("...") || dataArry[i+1].content!.containsString("...")){
                        continue
                    }
                    inarray.appendContentsOf(dataArry[i].content)
                    ouarray.appendContentsOf(dataArry[i+1].content)
                    ouarray2.appendContentsOf(dataArry[i+2].content)
                }
                do{
                    try inarray.writeToFile(insp, atomically: true, encoding: NSUTF8StringEncoding)
                }catch{
                    print("!")
                }
                do{
                    try ouarray.writeToFile(ousp, atomically: true, encoding: NSUTF8StringEncoding)
                }catch{
                    print("!!")
                }
                do{
                    try ouarray2.writeToFile(ousp2, atomically: true, encoding: NSUTF8StringEncoding)
                }catch{
                    
                }
                print(insp)
                dispatch_semaphore_signal(self.semaphore)
            }
        })
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        self.mbp?.hide(true)
        MBProgressHUD.showSuccess("操作完成")
        sleep(1)
        MBProgressHUD.hideHUD()
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        print("完成")
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
