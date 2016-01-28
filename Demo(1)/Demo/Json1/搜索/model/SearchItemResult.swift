//
//  SearchItemResult.swift
//  Demo
//
//  Created by Jason on 15/12/10.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class SearchItemResult: NSObject {
    
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
