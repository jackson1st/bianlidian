//
//  GoodDetail.swift
//  Demo
//
//  Created by Jason on 15/12/6.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class GoodDetail: NSObject {
    
    var barcode: String?
    
    var eshopIntegral:Int!
    var itemBynum1: String!
    var itemName: String!
    var itemNo: String!
    var itemSalePrice: String!
    var itemStocks: [ItemStock]!
    var itemUnits: Array<ItemUnit>!
    var imageDetail: [String]!
    var imageTop: [String]!
    var comments: [Comment]?
}

class ItemStock: NSObject {
    
    var shopName: String?
    var stockQty: Int?
    
    convenience init(name: String?, qty: Int?){
        self.init()
        self.shopName = name == nil ? "无" : name
        self.stockQty = qty == nil ? 0 : qty
    }
}

class ItemUnit: NSObject {
    
    var salePrice: String?
    var sizeName: String?
    
    convenience init(salePrice: String?, sizeName: String?){
        self.init()
        self.salePrice = salePrice == nil ? "无" : salePrice
        self.sizeName = sizeName == nil ? "无" : sizeName
    }
}

class Comment: NSObject{
    
    var content: String?
    var date: String?
    var userName: String?
    
    convenience init(content: String?,date: String?,userName: String?){
        self.init()
        self.content = content == nil ? "无" : content
        self.date = date == nil ? "无" : date
        self.userName = userName == nil ? "无" : userName
    }
    
}


