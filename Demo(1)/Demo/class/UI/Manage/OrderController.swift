//
//  OrderController.swift
//  Management
//
//  Created by mac on 15/12/15.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class OrderController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var order: orderInfo!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = theme.SDBackgroundColor
    }

}
extension OrderController {
}


extension OrderController: UITableViewDelegate,UITableViewDataSource {
    
    internal  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(section == 0 ) {
            return 2
        }
        else if(section == 1) {
            return 2 + order.itemList.count
        }
        else {
            return 1
        }
    }
    internal func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    internal func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return 90.0
        }
        else if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                return 40.0
            }
            if(indexPath.row <= order.itemList.count) {
                return 80.0
            }
            else {
                return 40.0
            }
        }
        else {
            return 105.0
        }
        return 0
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = ""
        if(indexPath.section == 0){
            if(indexPath.row == 0) {
                cellId = "OrderCell"
            }
            else {
                cellId = "AddressCell"
            }
        }
        else if(indexPath.section == 1){
            if(indexPath.row == 0) {
                cellId = "GoodCell"
            }
            else if(indexPath.row <= order.itemList.count){
                cellId = "goodCell"
            }
            else {
                cellId = "PriceCell"
            }
        }
        else {
            cellId = "orderCell"
        }
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.selectionStyle = .None
        }
        if(cellId == "OrderCell"){
            let dingDanZhuangTai = cell?.viewWithTag(10001) as! UILabel
            let dingDanJinE = cell?.viewWithTag(10002) as! UILabel
            let youHui = cell?.viewWithTag(10003) as! UILabel
            dingDanZhuangTai.text = "待确认"
            dingDanJinE.text = "订单金额: ￥\(self.order.totalAmt!)"
            youHui.text = "优惠: ￥\(self.order.freeAmt!)"
        }
        if(cellId == "AddressCell"){
            let diZhi = cell?.viewWithTag(20001) as! UILabel
            let shouJi = cell?.viewWithTag(20002) as! UILabel
            let beiZhu = cell?.viewWithTag(20003) as! UILabel
            diZhi.text = "收货地址: \(order.address)"
            shouJi.text = "手机: \(order.tel)"
            beiZhu.text = "备注: 无"
//            let attributeText1 = NSMutableAttributedString(string: "数量: \(self.orderArray[0].listorder[indexPath.section].itemList[0].subQty!)")
//            attributeText1.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText1.length - 3))
//            shuliang.attributedText = attributeText1
        }
        if(cellId == "GoodCell"){
            let shuLiang = cell?.viewWithTag(30005) as! UILabel
            shuLiang.text = "商品共\(order.itemNum!)件"
        }
        if(cellId == "goodCell"){
            let mingCheng = cell?.viewWithTag(40001) as! UILabel
            let jinE = cell?.viewWithTag(40002) as! UILabel
            let shuLiang = cell?.viewWithTag(40003) as! UILabel
            let heJi = cell?.viewWithTag(40004) as! UILabel
            mingCheng.text = "\(order.itemList[indexPath.row - 1].itemName!)"
            jinE.text = "￥\(order.itemList[indexPath.row - 1].realPrice!)"
            let attributeText1 = NSMutableAttributedString(string: "数量: \(order.itemList[indexPath.row - 1].subQty!)")
            attributeText1.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText1.length - 3))
            shuLiang.attributedText = attributeText1
            let attributeText2 = NSMutableAttributedString(string: "合计: ￥\(order.itemList[indexPath.row - 1].subAmt!)")
            attributeText2.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText2.length - 3))
            heJi.attributedText = attributeText2
            
        }
        if(cellId == "PriceCell"){
            let shiFu = cell?.viewWithTag(50001) as! UILabel
            let attributeText1 = NSMutableAttributedString(string: "实付: ￥\(order.totalAmt! - order.freeAmt!)")
            attributeText1.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText1.length - 3))
            shiFu.attributedText = attributeText1
        }
        if(cellId == "orderCell"){
            let dinDanHao = cell?.viewWithTag(60001) as! UILabel
            let xiaDanShiJian = cell?.viewWithTag(60002) as! UILabel
            let faHuoShiJian = cell?.viewWithTag(60003) as! UILabel
            let zhiFuFangShi = cell?.viewWithTag(60004) as! UILabel
            dinDanHao.text = "订单号: \(order.orderNo!)"
            xiaDanShiJian.text = "下单时间: \(order.payDate!)"
            faHuoShiJian.text = "发货时间: 尽快发货"
            zhiFuFangShi.text = "支付方式: 货到付款"
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
}
