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


class PayViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    var payModel: [JFGoodModel] = []
    @IBOutlet var sumPrice: UILabel!
    @IBOutlet var discountPrice: UILabel!
    @IBAction func okSelect(sender: AnyObject) {
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
        }
        let lookPayFromAddressAction = UIAlertAction(title: "查看订单", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            
            NSNotificationCenter.defaultCenter().postNotificationName("finishAOrder", object: self)
            self.dismissViewControllerAnimated(false, completion: nil)
        }

        let payFromAddressAction = UIAlertAction(title: payFromAddress, style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            print("使用了货到付款")
            let titleInfo = "订单确认"
            let message = "订单已经成功生成，商家正在准备配送，3小时后确认收货"
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
        sumPrice.text = needPay
        discountPrice.text = discount
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool){

        super.viewWillAppear(animated)
    
    }
    // MARK: - 懒加载TabViewcellId
    private lazy var mineTitles: NSMutableArray = NSMutableArray(array: ["AddressCell", "TimeCell", "RemarksCell", "BillCell", "CouponCell","ShopCell","NoAddressCell"])
}


    // MARK: - tableview 的datasource 和 delegate

extension PayViewController: UITableViewDataSource,UITableViewDelegate {
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
        return 20
    }
    internal func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            if UserAddress.userIsAddress() == false {
                return 52
            }
            else {
                return 70
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
                print(1)
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
           
        } else if indexPath.section == 3 {
           let name = cell?.viewWithTag(20011) as? UILabel
           let remark = cell?.viewWithTag(20012) as? UILabel
           let many = cell?.viewWithTag(20013) as? UILabel
           let price = cell?.viewWithTag(20014) as? UILabel
           name?.text = self.payModel[indexPath.row].itemName
           remark?.text = self.payModel[indexPath.row].itemSize
           many?.text = "×\(self.payModel[indexPath.row].num)"
           price?.text = "￥\(self.payModel[indexPath.row].totalPrice)"
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let addstroy = UIStoryboard(name: "PayStoryboard", bundle: nil)
            let vc = addstroy.instantiateViewControllerWithIdentifier("AddVc") as! AddressController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - 自定义delegate
extension PayViewController: OkDelegate {
    func returnOk(ok: String){
        if(ok == "true"){
            self.tableView.reloadData()
        }
    }
}
