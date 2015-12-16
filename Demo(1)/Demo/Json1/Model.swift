//
//  Model.swift
//  849
//
//  Created by jason on 15/12/11.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit

let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true)[0]
let filePath = documentPath + "/shopCart.data"


class Model: NSObject {
    
    static let defaultModel = Model()
    let userDefault = NSUserDefaults()
    lazy var shopCart: [JFGoodModel] = {
        var modes = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [JFGoodModel]
        if( modes == nil){
            modes = [JFGoodModel]()
        }
        return modes!
    }()

    private override init(){
        super.init()
        loadDataForNetWork()
    }
    
    //从服务器加载数据
    func loadDataForNetWork(){
        let address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
        //获取用户id
        let userID = "xx"
        let json: JSONND = ["cust":userID,
            "areaName":address]
        Pitaya.build(HTTPMethod: .POST, url: "http://192.168.199.241:8080/BSMD/car/showCar.do").setHTTPBodyRaw(json.RAWValue, isJSON: true).responseJSON { (json, response) -> Void in
            if let showCar = json.data as? NSDictionary{
                if let jfModellist = showCar["showcar"] as? NSArray {
                    for var i=0 ; i<jfModellist.count ; i++ {
                        if let jfModel = jfModellist[i] as? NSDictionary{
                            let JFmodel = JFGoodModel()
                            JFmodel.url = jfModel["url"] as? String
                            JFmodel.num = jfModel["num"] as! Int
                            JFmodel.itemName = jfModel["itemName"] as? String
                            JFmodel.itemSize = jfModel["itemSize"] as? String
                            let itemSalePrice = jfModel["itemSalePrice"] as? Double
                            let itemDistPrice = jfModel["itemDistPrice"] as? Double
                            JFmodel.itemSalePrice = "\(itemSalePrice! - itemDistPrice!)"
                            JFmodel.itemDistPrice = "\(itemSalePrice!)"
                            print(JFmodel.itemDistPrice)
                            if let shopnamelist = jfModel["shopNameList"] as? NSArray{
                                var arr: [ShopName] = []
                                for var j=0 ; j<shopnamelist.count ; j++ {
                                    if let shopname = shopnamelist[j] as? NSDictionary{
                                        let spName = ShopName()
                                        spName.shopName = shopname["shopName"] as? String
                                        spName.stockQty = shopname["stockQty"] as? Int
                                        spName.onArea = shopname["onArea"] as? Bool
                                        arr.append(spName)
                                    }
                                    JFmodel.shopNameList = arr
                                }
                                self.shopCart.append(JFmodel)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func uploadData(){
        
    }
    
    //从本地加载数据
//
//    var addDate: Int?
//    var barcode: String?
//    var custNo: String?
//    var itemNo: String?
//    var itemPack: Int?
//    var shopNameList: [ShopName]!
//    var canChange: Bool = false
//    var alreadyAddShoppingCart: Bool = false
//    var url: String?
//    var itemName: String?
//    var itemSize: String?
//    var num: Int = 1
//    var  itemSalePrice: String?
//    var itemDistPrice: String?
//    var totalPrice: Int?
//    var selected: Bool = true
//    static func customClassMapping() -> [String : String]? {
//        return ["shopNameList" : "\(ShopName.self)"]
//    }
//}
//class ShopName: NSObject{
//    var stockQty: Int?
//    var shopName: String?
//    var onArea: Bool?
//}
    
}
