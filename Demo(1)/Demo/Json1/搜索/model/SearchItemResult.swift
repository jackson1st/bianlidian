//
//  SearchItemResult.swift
//  Demo
//
//  Created by Jason on 15/12/10.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class SearchItemResult: NSObject {
    
    /**
    brandName = "\U96f7\U67cf";
    eshopIntegral = "<null>";
    itemBynum1 = "1650\U4eba";
    itemName = "j\U673a\U68b0\U952e\U76d8";
    itemNo = 10001;
    itemSalePrice = "\U00a546.50";
    url = "http://192.168.199.242:8080/BSMD/Android/image/index_img_i4.png";
    */
    var brandName: String?
    var eshopIntegral: Double?
    var name: String?
    var saleNum: String?
    var No: String?
    var price: String?
    var imgurl: String?
    
    convenience init(no: String!,name: String?,itemByNum: String?,price: String?, brandName: String?,eshopIntergral: Double?,url: String?) {
        self.init()
        self.No = no
        self.name = name==nil ? "无":name
        self.saleNum = itemByNum == nil ? "无":itemByNum
        self.price = price == nil ? "无":price
        self.brandName = brandName == nil ? "无":brandName
        self.eshopIntegral = eshopIntegral == nil ? 0:eshopIntergral
        self.imgurl = url == nil ? "无":url
    }
}
