//
//  OrderModel.swift
//  Demo
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import Foundation

class OrderModel: NSObject {
    var pageIndex: Int?
    var listorder: [orderInfo]!
}
class orderInfo: NSObject {
    //订单编号
    var orderNo: String?
    //订单总价
    var totalAmt: Double?
    //优惠价格
    var freeAmt: Double?
    //订单日期
    var payDate: String?
    var lodat: Int!
    //地址
    var address: String?
    //电话
    var tel: String?
    //总数量
    var itemNum: Int?
    var itemList: [goodList]!
}
class goodList: NSObject {
    //规格单位
    var nowUnit: String?
    //规格数量
    var nowPack: Int?
    //总数量
    var subQty: Int?
    //总价格
    var subAmt: Double?
    //图片URL
    var url: String?
    //商品名称
    var itemName: String?
    //最终价格
    var realPrice: Double?
    //删减前价格
    var orgPrice: Double?
}