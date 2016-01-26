//
//  CollectionModel.swift
//  Demo
//
//  Created by Jason on 1/26/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit

class CollectionModel: NSObject {
    static let CollectionCenter = CollectionModel()
    var Likes = [LikedModel]()
    var dict = [String: Int]()
    private override init(){
        super.init()
    }
    
    ///检查是否存在
    func find(no: String) -> Bool{
        print(dict[no])
        if(dict[no] != nil){
            return true
        }else{
            return false
        }
    }
    
    func findOfIndex(no: String) -> Int{
        
        return dict[no]!
    }
    
    /// 加入收藏
    func addLiked(no: String,success: (()->Void)?){
        HTTPManager.POST(ContentType.CollectionAdd, params: ["custno": UserAccountTool.userCustNo()!,"itemNo":no]).responseJSON({ (json) -> Void in
            print(json)
            //执行回调
            self.loadDataFromNet(success)
            
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
    }
    
    
    /// 删除收藏
    func removeAtNo(no: String,success: (()->Void)?){
        let index = findOfIndex(no)
        let model = Likes[index]
        HTTPManager.POST(ContentType.CollectionDelete, params: ["custno": UserAccountTool.userCustNo()!,"itemNo":model.no]).responseJSON({ (json) -> Void in
            print(json)
            //执行回调
            self.loadDataFromNet(success)
            
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
    }
    
    
    func loadDataFromNet(success: (() -> Void)?){
        if(UserAccountTool.userIsLogin()){
            Likes.removeAll()
            dict.removeAll()
            HTTPManager.POST(ContentType.CollectionGet, params: ["custno": UserAccountTool.userCustNo()!]).responseJSON({ (json) -> Void in
                if(json["code"] as! String == "success"){
                    let arr = json["collection"] as! NSArray
                    for(var i = 0; i < arr.count; i++){
                        let x = arr[i] as! NSDictionary
                        print(x)
                        let model = LikedModel(No: x["item_no"] as! String, price: x["item_sale_price"] as? String, name: x["item_name"] as! String, url: x["url"] as! String, unitNo: x["item_unit_no"] as? String, size: x["item_size"] as? String, pack: x["item_pack"] as? String)
                        self.Likes.append(model)
                        self.dict[model.no] = i
                    }
                }
                
                if(success != nil){
                    success!()
                }
                }, error: { (error) -> Void in
                    print("发生了错误: " + (error?.localizedDescription)!)
            })
        }
    }
    
}

//item_sale_price,
//item_name,
//url,
//item_unit_no,
//item_pack,
//item_size
class LikedModel: NSObject {
    var no: String!
    var price: String!
    var name:  String!
    var url:   String!
    var unitNo: String!
    var size: String!
    var pack: String!
    
    override init(){
        super.init()
    }
    
    convenience init(No: String,price: String?,name: String,url: String,unitNo: String?,size: String?,pack: String?){
        self.init()
        self.no = No
        self.price = price ?? "无"
        self.name = name
        self.url = url
        self.unitNo = unitNo ?? "无"
        self.size = size ?? "无"
        self.pack = pack ?? "无"
    }
}