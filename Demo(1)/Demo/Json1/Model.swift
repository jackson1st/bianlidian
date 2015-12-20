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
let shopFilePath = documentPath + "/shop.data"

class Model: NSObject {
    
    static let defaultModel = Model()
    var userID: String!
    let userDefault = NSUserDefaults()
    lazy var shopCart: [JFGoodModel] = {
        var modes = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [JFGoodModel]
        if( modes == nil){
            modes = [JFGoodModel]()
        }
        return modes!
    }()
    lazy var shopLists:[Shop] = {
        var modes = NSKeyedUnarchiver.unarchiveObjectWithFile(shopFilePath) as? [Shop]
        if(modes == nil){
            modes = [Shop]()
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
        if UserAccountTool.userIsLogin() {
        userID = userDefault.objectForKey(SD_UserDefaults_Account) as! String
        let json: JSONND = ["cust":userID,"areaName":address]
        Pitaya.build(HTTPMethod: .POST, url: "http://192.168.199.241:8080/BSMD/car/showCar.do").setHTTPBodyRaw(json.RAWValue, isJSON: true).responseJSON { (json, response) -> Void in
            if let showCar = json.data as? NSDictionary{
                if let shopList = showCar["allShop"] as? NSArray{
                    for var x in shopList{
                        let model = Shop()
                        model.shopNo = x["shopNo"] as? String
                        model.shopName = x["shopName"] as? String
                        self.shopLists.append(model)
                    }
                }
                if let jfModellist = showCar["cartList"] as? NSArray {
                    print(jfModellist)
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
                            print(JFmodel.itemSalePrice)
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
                                JFmodel.needUp = false
                                self.shopCart.append(JFmodel)
                            }
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName("finishLoadDataFromNetwork", object: self)
                    }
                }
            }
         }
       }
    }
    
    func uploadData(){
        var str = NSMutableString(string: "{\"itemlist\":[")
        var cur = 0
        var count = 0
        for var x in shopCart{
            if(x.needUp == false){
                continue
            }
            count++
            let json:JSONND = ["custNo":userID,"itemNo": x.itemNo!,"num":"\(x.num)","itemSize":x.itemSize!]
            if(cur == 0){
                str.appendString(json.RAWValue)
            }else{
                str.appendString("," + json.RAWValue)
            }
            cur++
        }
        
        str.appendString("]}")
        if(count == 0){
            return
        }
        
        Pitaya.build(HTTPMethod: .POST, url: "http://192.168.199.241:8080/BSMD/car/addToCar.do").setHTTPBodyRaw(str as String, isJSON: true).responseJSON { (json, response) -> Void in
            print(json.data)
        }
    }
    
}
