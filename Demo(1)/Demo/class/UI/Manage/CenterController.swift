//
//  CenterCOntroller.swift
//  Management
//
//  Created by mac on 15/12/14.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class CenterController: UIViewController {
    @IBOutlet var tableView: UITableView!
     var timer:NSTimer!
    private var orderArray: [OrderModel] = []
    var datePicker: UIDatePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        timer = NSTimer.scheduledTimerWithTimeInterval(10,
            target:self,selector:Selector("tickDown"),
            userInfo:nil,repeats:true)
    }
    
    func tickDown()
    {
        print("进行了一次")
        loadDataModel("-1")
    }
// MARK: -准备UI
    func prepareUI(){
        tableView.dataSource = self
        tableView.delegate = self
        loadDataModel("-1")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "didTappedBackButton")
    }
    func didTappedBackButton(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func loadDataModel(orderStatu: String) {
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        let parameters = ["No":"101","pageIndex":1,"pageCount":5,"orderStatu":orderStatu]
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //这里写需要大量时间的代码
            print("这里写需要大量时间的代码")
            dispatch_async(dispatch_get_main_queue(), {
                manager.POST("http://192.168.199.134:8080/BSMD/order/select/shop", parameters: parameters, success: { (oper, data) -> Void in
//                    print(data)
                    var expArray: [OrderModel] = []
                    if let orderpage = data as? NSDictionary {
                        if let page = orderpage["orderPage"] as? NSDictionary {
                            let exp = OrderModel()
                            exp.listorder = []
                            exp.pageIndex = page["pageIndex"] as! Int
                            if let list = page["list"] as? NSArray {
                                for var i=0 ; i<list.count ; i++ {
                                    let listorder = orderInfo()
                                    if let oinfo = list[i]["orderInfo"] as? NSDictionary {
                                        listorder.orderNo = oinfo["orderNo"] as? String
                                        listorder.totalAmt = oinfo["totalAmt"] as? Double
                                        listorder.freeAmt = oinfo["freeAmt"] as? Double
                                        listorder.lodat = oinfo["createDate"] as! Int
                                        listorder.payDate = oinfo["createDateString"] as! String
                                        listorder.itemNum  = oinfo["itemNum"] as! Int
                                        if let receiveAddress = list[i]["receiveAddress"] as? NSDictionary {
                                            listorder.address = receiveAddress["address"] as?
                                            String
                                            listorder.tel = receiveAddress["tel"] as? String
                                        }
                                    }
                                    if let item = list[i]["itemList"] as? NSArray {
                                        listorder.itemList = []
                                        for var j=0 ; j<item.count ; j++ {
                                            let itemList = goodList()
                                            itemList.nowUnit = item[j]["nowUnit"] as? String
                                            itemList.nowPack = item[j]["nowPack"] as!
                                            Int
                                            itemList.subQty = item[j]["subQty"] as! Int
                                            itemList.subAmt = item[j]["subAmt"] as? Double
                                            itemList.orgPrice = item[j]["orgPrice"] as? Double
                                            itemList.realPrice = item[j]["realPrice"] as?
                                            Double
                                            if let good = item[j]["item"] as? NSDictionary {
                                                itemList.itemName = good["itemName"] as? String
                                                itemList.url = good["url"] as? String
                                            }
                                            listorder.itemList?.append(itemList)
                                        }
                                    }
                                    if(self.orderArray.count > 0){
                                        if(self.orderArray[0].listorder[0].lodat >= listorder.lodat) {
                                            break;
                                        }
                                        else {
                                            self.orderArray[0].listorder.append(listorder)
                                            for var i = self.orderArray[0].listorder.count - 2; i>=0; i-- {
                                            print(i)
                                            self.orderArray[0].listorder[i + 1] = self.orderArray[0].listorder[i]
                                            }
                                            self.orderArray[0].listorder[0] = listorder
                                            self.addLocalNotification()
                                            self.tableView.reloadData()
                                        }
                                    }
                                    else {
                                    exp.listorder?.append(listorder)
                                    }
                                }
                            }
                            expArray.append(exp)
                        }
                    }
                    if(self.orderArray.count < 1) {
                    print(self.orderArray.count)
                    self.orderArray = expArray
                    }
                    self.tableView.reloadData()
                    }) { (opeation, error) -> Void in
                        print(error)
                }
            })
        })
    }

}
extension CenterController {
    func addLocalNotification() {
        var notification = UILocalNotification()
        //通知触发的时间，10s以后
        notification.fireDate = NSDate(timeIntervalSinceNow: 1.0)
        //通知重复次数
        //        notification.repeatInterval = NSCalendarUnit.Calendar
        //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
//        notification.alertBody = "您有新的订单了!" //通知主体
//        notification.applicationIconBadgeNumber = 1//应用程序图标右上角显示的消息数
//        notification.alertAction = "打开应用"//待机界面的滑动动作提示
//        notification.alertLaunchImage = "quesheng"//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        notification.soundName = UILocalNotificationDefaultSoundName
        //        notification.soundName = ""//通知声音（需要真机才能听到声音）
//        notification.userInfo = ["id": 1,"user":"Kenshin Cui"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    func removeNotification (){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

}
extension CenterController: UITableViewDataSource,UITableViewDelegate {
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderArray.count == 0 {
            return 0
        }
        else {
            
            return self.orderArray[0].listorder.count ?? 0
        }
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = ""
        cellId = "orderCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
        }
        let dingDan = cell?.viewWithTag(1001) as! UILabel
        let riQi = cell?.viewWithTag(1002) as! UILabel
        riQi.text = orderArray[0].listorder[indexPath.row].payDate
       return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let story = UIStoryboard(name: "Center", bundle: nil)
        let vc = story.instantiateViewControllerWithIdentifier("orderInformation") as? OrderController
        vc?.order = self.orderArray[0].listorder[indexPath.row]
        vc?.user = 2
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}