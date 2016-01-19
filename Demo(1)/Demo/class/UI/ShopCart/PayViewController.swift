//
//  PayViewController.swift
//  webDemo
//
//  Created by mac on 15/12/5.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit

public let SD_UserDefaults_Name = "SD_UserDefaults_Name"
public let SD_UserAddress_Notification = "SD_UserAddress_Notification"
public let SD_UserDefaults_Telephone = "SD_UserDefaults_Telephone"
public let SD_UserDefaults_Address = "SD_UserDefaults_Address"
public let SD_OrderInfo_Note = "SD_OrderInfo_Note"

protocol payDelegate: NSObjectProtocol {
    func returnOk(ok: String)
}
class PayViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var delegate: payDelegate?
    var payModel: [JFGoodModel] = []
    var sumprice: String!
    var disprice: String!
    var sendTime: String = "尽快送达"
    var noteInfo: String?
    @IBOutlet var sumPrice: UILabel!
    @IBOutlet var discountPrice: UILabel!
    @IBAction func canBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func okSelect(sender: AnyObject) {
        print("我点了确认下单")
        let title = "选择付款方式"
        let messge = ""
        let payFromAddress = "货到付款"
        let payFromZhiFuBao = "支付宝付款"
        let backTitle = "返回"
        let ispay = UIAlertController(title: title, message: messge, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelAction = UIAlertAction(title: backTitle, style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            print("取消了订单")
        }
        let okPayFromAddressAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.delegate?.returnOk("true")
             self.dismissViewControllerAnimated(true, completion: nil)
        }
        let lookPayFromAddressAction = UIAlertAction(title: "查看订单", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.delegate?.returnOk("true")
            let OrederStoryBoard = UIStoryboard(name: "MyOrderStoryBoard", bundle: nil)
            let orderVC = OrederStoryBoard.instantiateViewControllerWithIdentifier("OrderView") as? OrderViewController
            orderVC!.ispush = false
            self.navigationController!.pushViewController(orderVC!, animated: true)
        }

        let payFromAddressAction = UIAlertAction(title: payFromAddress, style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("使用了货到付款")
            self.sentOrderInformation()
            let titleInfo = "订单确认"
            let message = "订单已经成功生成，商家正在准备配送，3小时后自动确认收货"
            let isOk = UIAlertController(title: titleInfo, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            isOk.addAction(okPayFromAddressAction)
            isOk.addAction(lookPayFromAddressAction)
            self.presentViewController(isOk, animated: true, completion: nil)
        }
        let payFromZhiFbaoAcction = UIAlertAction(title: payFromZhiFuBao, style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("使用了支付宝付款")
        }
        ispay.addAction(cancelAction)
        ispay.addAction(payFromZhiFbaoAcction)
        ispay.addAction(payFromAddressAction)
        self.presentViewController(ispay, animated: true, completion: nil)

    }
    internal var needPay: String!
    internal var discount: String!
    // MARK: - view生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController!.tabBar.hidden = true
        sumPrice.text = needPay
        discountPrice.text = discount
        tableView.delegate = self
        tableView.dataSource = self
        let frame = CGRectMake(0, 0, 0, -0.0001)
        self.tableView.tableHeaderView = UIView.init(frame: frame)
        self.navigationItem.title = "确认订单"
//        backBtn.setImage(UIImage(named: "back_1"), forState: .Normal)
//        backBtn.setImage(UIImage(named: "back_2"), forState: .Highlighted)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
    
    override func viewWillAppear(animated: Bool){

        super.viewWillAppear(animated)
    
    }
    // MARK: - 懒加载TabViewcellId
    private lazy var mineTitles: NSMutableArray = NSMutableArray(array: ["AddressCell", "TimeCell", "RemarksCell", "BillCell", "CouponCell","ShopCell","NoAddressCell"])
    lazy var backBtn: UIButton = {
        //设置返回按钮属性
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.titleLabel?.font = UIFont.systemFontOfSize(17)
        backBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        backBtn.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        backBtn.setImage(UIImage(named: "back_1"), forState: .Normal)
        backBtn.setImage(UIImage(named: "back_2"), forState: .Highlighted)
        backBtn.addTarget(self, action: "didTappedBackButton", forControlEvents: .TouchUpInside)
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
        backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        let btnW: CGFloat = AppWidth > 375.0 ? 50 : 44
        backBtn.frame = CGRectMake(0, 0, btnW, 40)
        return backBtn
    }()
}

extension PayViewController {
    func didTappedBackButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func modelChangeDict() -> NSMutableDictionary{
        //地址信息封装成dictitionary
        let address = UserAddress.userAccount()!
        let receiveAddress: NSMutableDictionary = NSMutableDictionary()
        receiveAddress.setObject(address[2], forKey: "address")
        receiveAddress.setObject(address[1], forKey: "tel")
        //封装orderinfo
        let orderInfo: NSMutableDictionary = NSMutableDictionary()
        orderInfo.setObject(self.payModel[0].custNo!, forKey: "custNo")
        orderInfo.setObject(self.sumprice, forKey: "totalAmt")
        orderInfo.setObject(self.disprice, forKey: "freeAmt")
        orderInfo.setObject("202",forKey: "shopNo")
        orderInfo.setObject("1", forKey: "addrNo")
        orderInfo.setObject(receiveAddress, forKey: "receiveAddress")
        //封装itemList
        let itemList: NSMutableArray = NSMutableArray()
        for var i=0; i<self.payModel.count; i++ {
            //单个商品
            let shop: NSMutableDictionary = NSMutableDictionary()
            shop.setObject(self.payModel[i].barcode!, forKey: "barcode")
            shop.setObject(self.payModel[i].num, forKey: "subQty")
            itemList.addObject(shop)
        }
        let dict: NSMutableDictionary = NSMutableDictionary()
        dict.setObject(orderInfo, forKey: "orderInfo")
        dict.setObject(itemList, forKey: "itemList")
        return dict
    }
    func returnbranchInfo() -> NSMutableDictionary{
        let dict: NSMutableDictionary = NSMutableDictionary()
        let barcodes: NSMutableArray = NSMutableArray()
        for var i=0; i<self.payModel.count; i++ {
            barcodes.addObject(payModel[i].barcode!)
        }
        dict.setObject(barcodes, forKey: "barcodes")
        dict.setObject(payModel[0].custNo!, forKey: "custNo")
        return dict
    }
    func sentOrderInformation() -> Bool{
        let userDefault = NSUserDefaults()
        var userID: String?
        if UserAccountTool.userIsLogin() {
         userID = userDefault.objectForKey(SD_UserDefaults_Account) as? String
        }
        let parameters: [String : AnyObject] = [ userID! : modelChangeDict()]
        
        HTTPManager.POST(ContentType.OrderAdd, params: parameters).responseJSON { (json, response) -> Void in
            
            
        }
//                        SVProgressHUD.showErrorWithStatus("数据加载失败，请检查网络连接", maskType: SVProgressHUDMaskType.Black)
        return true
    }
}
    // MARK: - tableview 的datasource 和 delegate

extension PayViewController: UITableViewDataSource,UITableViewDelegate{
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return 1
        }
        else if(section == 1) {
            return 3
        }
        else if(section == 2) {
            return 1
        }
        else {
            return self.payModel.count
        }
    }
    internal func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    internal func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            if UserAddress.userIsAddress() == false {
                return 52
            }
            else {
                return 80
            }
        }
        else if(indexPath.section == 1 || indexPath.section == 2) {
            return 44
        }
        else {
            return 52
        }
    }
    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = ""
        if(indexPath.section == 0){
            if UserAddress.userIsAddress() == false {
                cellId = "NoAddressCell"
            }
            else {
                cellId = mineTitles[indexPath.section + indexPath.row] as! String
            }
        }
        else if(indexPath.section == 1){
        cellId = mineTitles[indexPath.section + indexPath.row] as! String
        }
        else if(indexPath.section == 2){
        cellId = mineTitles[indexPath.section + 2] as! String
        }
        else {
        cellId = mineTitles[5] as! String
        }
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        if indexPath.section == 0 && cellId == "AddressCell"{
           let name = cell?.viewWithTag(10011) as? UILabel
           let tele = cell?.viewWithTag(10012) as? UILabel
           let address = cell?.viewWithTag(10013) as? UILabel
           let ad: [String] = UserAddress.userAccount()!
           name?.text = ad[0]
           tele?.text = ad[1]
           address?.text = ad[2]
//           let viewLine = UIView(frame: CGRectMake(0, self.view.height - 1, self.view.frame.size.width, 1/((UIScreen.mainScreen()).scale)))
//           viewLine.backgroundColor = UIColor.redColor()
//           self.view.addSubview(viewLine)
           
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell?.detailTextLabel?.text = sendTime
            }
            if indexPath.row == 1 {
                noteInfo = OrderInfo.orderInfoNote()
                if noteInfo != "" {
                cell?.detailTextLabel?.text = noteInfo
                    print("noteinfo is \(noteInfo)")
                }
                else {
                    cell?.detailTextLabel?.text = "点击添加备注"
                }
            }
        }
        else if indexPath.section == 3 {
           let name = cell?.viewWithTag(20011) as? UILabel
           let remark = cell?.viewWithTag(20012) as? UILabel
           let many = cell?.viewWithTag(20013) as? UILabel
           let price = cell?.viewWithTag(20014) as? UILabel
           name?.text = self.payModel[indexPath.row].itemName
           remark?.text = self.payModel[indexPath.row].itemSize
           many?.text = "×\(self.payModel[indexPath.row].num)"
           price?.text = "￥\(self.payModel[indexPath.row].totalPrice!)"
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let addstroy = UIStoryboard(name: "PayStoryboard", bundle: nil)
        if indexPath.section == 0 {
            let vc = addstroy.instantiateViewControllerWithIdentifier("AddVc") as! AddressController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
              let  pickView = HRHDatePickerView.instanceDatePickerView()
                pickView!.frame = CGRectMake(0, 0, AppWidth, AppHeight + 20);
                pickView!.backgroundColor = UIColor.clearColor()
                pickView!.delegate = self
                var type = DateType.init(0)
                pickView!.type = type
                pickView.datePickerView?.datePickerMode = UIDatePickerMode.DateAndTime
                pickView.datePickerView?.minuteInterval = 15
                pickView.datePickerView?.minimumDate = NSDate()
                pickView!.datePickerView?.setDate(NSDate(), animated: true)
                self.view.addSubview(pickView!)
            }
            if indexPath.row == 1 {
                let vc = addstroy.instantiateViewControllerWithIdentifier("NoteView") as? NoteViewController
                vc?.delegate = self
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
}

// MARK: - 自定义delegate
extension PayViewController: OkDelegate {
    func returnOk(ok: String){
        if(ok == "true"){
            print("我接受了 true")
            self.tableView.reloadData()
        }
    }
}

extension PayViewController: HRHDatePickerViewDelegate {
    func getSelectDate(date: String!, type: DateType) {
        switch (type) {
        case DateTypeOfStart :
            sendTime = "\(date)"
            self.tableView.reloadData()
            break
        default:
            self.tableView.reloadData()
            break
        }
        
    }
}
