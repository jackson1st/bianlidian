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
    var dict = [String: Bool]()
    private override init(){
        super.init()
    }
    
    ///检查是否存在
    func find(no: String) -> Bool{
        if(dict[no] == true){
            return true
        }else{
            return false
        }
    }
    
    /// 加入收藏
    func addLiked(no: String,success: (()->Void)?){
        HTTPManager.POST(ContentType.CollectionAdd, params: ["username":UserAccountTool.userAccount()!,"itemNo":no]).responseJSON({ (json) -> Void in
            print(json)
            //执行回调
            self.loadDataFromNet(success)
            
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
    }
    
    /// 删除收藏
    func removeAtIndex(index: Int,success: (()->Void)?){
        let model = Likes[index]
        HTTPManager.POST(ContentType.CollectionDelete, params: ["username":UserAccountTool.userAccount()!,"itemNo":model.no]).responseJSON({ (json) -> Void in
            print(json)
            self.Likes.removeAtIndex(index)
            self.dict[model.no] = false
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
            HTTPManager.POST(ContentType.CollectionGet, params: ["username": UserAccountTool.userAccount()!]).responseJSON({ (json) -> Void in
                if(json["code"] as! String == "success"){
                    let arr = json["collection"] as! NSArray
                    print(arr)
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
    
    convenience init(No: String,price: String,name: String,url: String,unitNo: String,size: String,pack: String){
        self.init()
        self.no = No
        self.price = price
        self.name = name
        self.url = url
        self.unitNo = unitNo
        self.size = size
        self.pack = pack
    }
}