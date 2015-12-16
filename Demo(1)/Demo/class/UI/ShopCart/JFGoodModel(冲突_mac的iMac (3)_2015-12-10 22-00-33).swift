//
//  JFGoodModel.swift
//  shoppingCart
//
//  Created by jianfeng on 15/11/17.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
class JFGoodModels: NSObject,DictModelProtocol{
    var showcar: [JFGoodModel]?
    class func loadEventsData(completion: (data: JFGoodModels?, error: NSError?)->()) {
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        let parameters = ["cust":"cust01",
            "areaName":"明阳小区"]
        manager.POST("http://192.168.199.241:8080/BSMD/car/showCar.do", parameters: parameters, success: { (oper, dataWeb) -> Void in
                let dict: NSDictionary = dataWeb as! NSDictionary
                let modelTool = DictModelManager.sharedManager
                let data = modelTool.objectWithDictionary(dict, cls: JFGoodModels.self) as? JFGoodModels
//               print(data?.showcar)
                completion(data: data, error: nil)
        }) { (opeation, error) -> Void in
                print(error)
        }
    }
    static func customClassMapping() -> [String : String]? {
        return ["showCar" : "\(JFGoodModel.self)"]
    }
}



//@objc(JFGoodModel)
class JFGoodModel: NSObject,DictModelProtocol {
    var addDate: Int?
    var barcode: String?
    var custNo: String?
    var itemNo: String?
    var itemPack: Int?
    var shopNameList: [ShopName]!
    
    // 是否可以选择
    var canChange: Bool = false
    
    // 是否已经加入购物车
    var alreadyAddShoppingCart: Bool = false
    
    // 商品图片名称
    var url: String?
    
    // 商品标题
    var itemName: String?
    
    // 商品描述
    var itemSize: String?
    
    // 商品购买个数,默认0
    var num: Int = 1
    
    // 新价格
    var  itemSalePrice: String?
    
    // 老价格
    var itemDistPrice: String?
    var totalPrice: Double!
    // 是否选中，默认没有选中
    var selected: Bool = true
    static func customClassMapping() -> [String : String]? {
        return ["shopNameList" : "\(ShopName.self)"]
    }
////     字典转模型
//    init(dict: [String : AnyObject]) {
//        super.init()
//        
//        // 使用kvo为当前对象属性设置值
//        setValuesForKeysWithDictionary(dict)
//    }
//
//    required override public init() {
//        fatalError("init() has not been implemented")
//    }
//    
//    // 防止对象属性和kvc时的dict的key不匹配而崩溃
//    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
}
class ShopName: NSObject{
    var stockQty: Int?
    var shopName: String?
    var onArea: Bool?
}