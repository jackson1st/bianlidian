//
//  LocationViewController.swift
//  webDemo
//
//  Created by Jason on 15/11/17.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var textLable: UILabel!
    @IBOutlet weak var chooseLocation: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var firstTableView: UITableView?
    var secondTableView: UITableView?
    var thirdTableView: UITableView?
    var width = UIScreen.mainScreen().bounds.width
    var dict: NSDictionary?
    var firstArry: NSArray?,secondArry:NSArray?,thirdArry: NSArray?,selectArr:NSArray?
    var first: String?, second: String?, third: String?
    var cur: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        initArr()
        initView()
        initTitle()
        leftButton.setTitle("关闭", forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: - 一些初始化操作
    
    func initArr(){
        let manager2 = AFHTTPRequestOperationManager()
        manager2.responseSerializer = AFJSONResponseSerializer()
        //manager2.responseSerializer.acceptableContentTypes = NSSet(object: "appliaction/json") as Set<NSObject>
        manager2.requestSerializer = AFJSONRequestSerializer()
        let parameter = ["city":"Null","county":"Null"]
        manager2.POST("http://192.168.199.242:8080/BSMD/locate/city.do", parameters: parameter, success: { (operation, response) -> Void in
            print(response)
            self.firstArry = response.objectForKey("citys") as! NSArray
            //print(self.firstArry?.count)
            self.firstTableView?.reloadData()
            }) { (operation, error ) -> Void in
                print(error)
        }
        
    }
    
    func initTitle(){
        textLable.text = ""
        textLable.textColor = UIColor.whiteColor()
        let userDefault = NSUserDefaults.standardUserDefaults()
        if(userDefault.boolForKey("needSetLocation") == true){
            first = userDefault.valueForKey("firstLocation") as! String
            second = userDefault.valueForKey("secondLocation") as! String
            third = userDefault.valueForKey("thirdLocation") as! String
            chooseLocation.text = first! + "-" + second! + "-" + third!
            textLable.text = "请选择您所在的市"
        }
    }
    //MARK: 初始化一些视图
    func initView(){
        let frame = CGRect(x: 0, y: -61, width: width, height: UIScreen.mainScreen().bounds.height-64-25)
        scrollView.frame = CGRect(x: 0, y: 25, width: width, height: UIScreen.mainScreen().bounds.height-25)
        scrollView.contentSize = CGSize(width: CGFloat(width*3), height: CGFloat(frame.height))
        scrollView.backgroundColor = UIColor.blackColor()
        firstTableView = UITableView(frame: frame, style: UITableViewStyle.Plain)
        firstTableView?.delegate = self
        firstTableView?.dataSource = self
        firstTableView?.tag = 101
        scrollView.addSubview(firstTableView!)
        secondTableView = UITableView(frame: CGRect(x: width, y: -61, width: width, height: UIScreen.mainScreen().bounds.height-64-25), style: UITableViewStyle.Plain)
        secondTableView?.delegate = self
        secondTableView?.dataSource = self
        secondTableView?.tag = 102
        scrollView.addSubview(secondTableView!)
        thirdTableView = UITableView(frame: CGRect(x: 2*width, y: -61, width: width+10, height: UIScreen.mainScreen().bounds.height-64-25), style: UITableViewStyle.Plain)
        thirdTableView?.delegate = self
        thirdTableView?.dataSource = self
        thirdTableView?.tag = 103
        scrollView.addSubview(thirdTableView!)
    }
    
    //MARK: - 实现代理
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = firstTableView!.dequeueReusableCellWithIdentifier("proCell")
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "proCell")
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        switch(tableView.tag){
        case 101:  cell?.textLabel?.text = firstArry![indexPath.row] as! String;
        case 102:  if(cur==2){ cell?.textLabel?.text = secondArry![indexPath.row] as! String}
        case 103:  if(cur==3){ cell?.textLabel?.text = thirdArry![indexPath.row] as! String}
        default:   break
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(cur){
        case 1: (firstArry?.count); return firstArry == nil ? 0 : (firstArry?.count)!
        case 2: return secondArry == nil ? 0 : (secondArry?.count)!
        case 3: return thirdArry == nil ? 0 : (thirdArry?.count)!
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(cur == 1){
            let manager2 = AFHTTPRequestOperationManager()
            manager2.responseSerializer = AFJSONResponseSerializer()
            //manager2.responseSerializer.acceptableContentTypes = NSSet(object: "appliaction/json") as Set<NSObject>
            manager2.requestSerializer = AFJSONRequestSerializer()
            let parameter = ["city":firstArry![indexPath.row],"county":"Null"]
            manager2.POST("http://192.168.199.242:8080/BSMD/locate/city.do", parameters: parameter, success: { (operation, response) -> Void in
                //print(response)
                self.secondArry = response.objectForKey("countys") as! NSArray
                //print(self.firstArry?.count)
                self.loadData()
                }) { (operation, error ) -> Void in
                    print(error)
            }
            first = firstArry![indexPath.row] as! String
            
        }
        if(cur == 2){
            let manager2 = AFHTTPRequestOperationManager()
            manager2.responseSerializer = AFJSONResponseSerializer()
            //manager2.responseSerializer.acceptableContentTypes = NSSet(object: "appliaction/json") as Set<NSObject>
            manager2.requestSerializer = AFJSONRequestSerializer()
            let parameter = ["city":firstArry![indexPath.row],"county":secondArry![indexPath.row]]
            manager2.POST("http://192.168.199.242:8080/BSMD/locate/city.do", parameters: parameter, success: { (operation, response) -> Void in
                //print(response)
                self.thirdArry = response.objectForKey("shops") as! NSArray
                self.loadData()
                //print(self.firstArry?.count)
                }) { (	operation, error ) -> Void in
                    print(error)
            }
            second = secondArry![indexPath.row] as! String
        }
        if(cur == 3){
            third = thirdArry![indexPath.row] as! String
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setValue(first, forKey: "firstLocation")
            userDefault.setValue(second, forKey: "secondLocation")
            userDefault.setValue(third, forKey: "thirdLocation")
            userDefault.setBool(true, forKey: "needSetLocation")
            userDefault.synchronize()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        cur++
    }
    //MARK: - 返回或者关闭
    @IBAction func leftButtonClicked() {
        if(cur == 1){
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            cur--
        }
        loadData()
    }
    //MARK: 重新加载数据
    func loadData(){
        switch(cur){
        case 1:
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.scrollView.contentOffset.x = 0
                }, completion: nil)
            leftButton.setTitle("关闭", forState: UIControlState.Normal)
            textLable.text = "请选择您所在的市"
            chooseLocation.text = " "
            break
        case 2:
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.scrollView.contentOffset.x = self.width
                }, completion: nil)
            leftButton.setTitle("返回", forState: UIControlState.Normal)
            textLable.text = "请选择您所在的区"
            chooseLocation.text = first!
            secondTableView!.reloadData()
            break
        case 3:
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.scrollView.contentOffset.x = self.width + self.width
                }, completion: nil)
            leftButton.setTitle("返回", forState: UIControlState.Normal)
            textLable.text = "请选择您附近的便利店"
            chooseLocation.text = first! + "-" + second!
            thirdTableView!.reloadData()
            break
        default: break
        }
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
