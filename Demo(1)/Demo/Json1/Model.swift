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
        var modes: [JFGoodModel]?
        if( modes == nil){
            modes = [JFGoodModel]()
        }
        return modes!
    }()
    
    
    var dict = [String: Bool]()
    
    
    lazy var shopLists:[Shop] = {
        var modes: [Shop]?
        if(modes == nil){
            modes = [Shop]()
        }
        return modes!
    }()
    
    
    
    
    
    
    func itemIsExist(itemNo: String) -> Bool {
        return dict[itemNo] == nil ? false : dict[itemNo]!
    }
    
    func addItem(model: JFGoodModel,success: () -> Void){
        let parm = ["itemlist":[["custNo":userID,"itemNo":model.itemNo,"num":"\(model.num)","itemSize":model.itemSize]]]
        print(parm)
        HTTPManager.POST(ContentType.PushItemToCar, params: parm).responseJSON({ (json) -> Void in
            print(json)
            self.loadDataForNetWork(success)
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
        
    }
    
    func removeAtIndex(index: Int, success: () -> Void){
        let model = shopCart[index]
        HTTPManager.POST(ContentType.DelFromCar, params: ["custNo":userID,"barcodes":[["barcode":model.barcode!]]]).responseJSON({ (json) -> Void in
            print(json)
            self.loadDataForNetWork(success)
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
        
    }
    
    func updataItemNum(index: Int, shopNo: String,dis: Int,success: () -> Void,callback:() -> Void){
        let model = shopCart[index]
        print(model.barcode)
        let num = model.num + dis
        HTTPManager.POST(ContentType.UpdateItemNum, params: ["custNo": userID,"barcode": model.barcode!,"shopNo": shopNo,"num":"\(num)"]).responseJSON({ (json) -> Void in
            if(json["result"] as! String == "success"){
                model.num = num
                success()
            }
            callback()
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
        
    }
    
    
    private override init(){
        super.init()
        loadDataForNetWork(nil)
    }
    
    //从服务器加载数据
    func loadDataForNetWork(success: (() -> Void)?){
        
        //获取用户id
        if UserAccountTool.userIsLogin() {
            userID = userDefault.objectForKey(SD_UserDefaults_CustNo) as? String
            if(userID == nil){
                return
            }
        let address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
            HTTPManager.POST(ContentType.ShowCarDetail, params: ["cust":userID,"areaName":address]).responseJSON({ (json) -> Void in
                print("json的内容:")
                self.shopCart.removeAll()
                self.dict.removeAll()
                print(json)
                if let showCar = json as? NSDictionary{
                    if let shopList = showCar["allShop"] as? NSArray{
                        for var x in shopList{
                            let model = Shop()
                            model.shopNo = x["shopNo"] as? String
                            model.shopName = x["shopName"] as? String
                            self.shopLists.append(model)
                        }
                    }
                    if let jfModellist = showCar["cartList"] as? NSArray {
                        for var i=0 ; i<jfModellist.count ; i++ {
                            if let jfModel = jfModellist[i] as? NSDictionary{
                                let JFmodel = JFGoodModel()
                                JFmodel.url = jfModel["url"] as? String
                                JFmodel.num = jfModel["num"] as! Int
                                JFmodel.itemName = jfModel["itemName"] as? String
                                JFmodel.itemSize = jfModel["itemSize"] as? String
                                JFmodel.itemNo = jfModel["itemNo"] as? String
                                JFmodel.barcode = jfModel["barcode"] as? String
                                //标记商品已经在购物车
                                self.dict[JFmodel.itemNo!] = true
                                
                                let itemSalePrice = jfModel["itemSalePrice"] as? Double
                                let itemDistPrice = jfModel["itemDistPrice"] as? Double
                                JFmodel.itemSalePrice = "\(itemSalePrice! - itemDistPrice!)"
                                JFmodel.itemDistPrice = "\(itemSalePrice!)"
                                JFmodel.totalPrice = itemSalePrice! * Double(JFmodel.num)
                                if let shopnamelist = jfModel["shopNameList"] as? NSArray{
                                    var arr: [Shop] = []
                                    for var j=0 ; j<shopnamelist.count ; j++ {
                                        if let shopname = shopnamelist[j] as? NSDictionary{
                                            let spName = Shop()
                                            spName.shopName = shopname["shopName"] as? String
                                            spName.shopNo = shopname["shopNo"] as? String
                                            arr.append(spName)
                                        }
                                        JFmodel.shopNameList = arr
                                    }
                                    JFmodel.needUp = false
                                    self.shopCart.append(JFmodel)
                                }
                            }
                        }
                    }
                }
                if success != nil{
                    success!()
                }
                NSNotificationCenter.defaultCenter().postNotificationName("CarNumChanged", object: nil)
                print(self.shopCart.count)
                print("一个Model")
                
                }, error: { (error) -> Void in
                    print("发生了错误: " + (error?.localizedDescription)!)
            })
        }
        else {
            return 
        }
    }
    
    
    func uploadData(){
//        var str = NSMutableString(string: "{\"itemlist\":[")
//        var cur = 0
//        var count = 0
//        for var x in shopCart{
//            if(x.needUp == false){
//                continue
//            }
//            count++
//            let json:JSONND = ["custNo":userID,"itemNo": x.itemNo!,"num":"\(x.num)","itemSize":x.itemSize!]
//            if(cur == 0){
//                str.appendString(json.RAWValue)
//            }else{
//                str.appendString("," + json.RAWValue)
//            }
//            cur++
//        }
//        
//        str.appendString("]}")
//        if(count == 0){
//            return
//        }
//        
//        Pitaya.build(HTTPMethod: .POST, url: "http://192.168.199.149:8080/BSMD/car/addToCar.do").setHTTPBodyRaw(str as String, isJSON: true).responseJSON { (json, response) -> Void in
//            print(json.data)
//        }
    }
    
}
