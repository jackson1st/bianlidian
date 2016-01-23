//
//  HTTPManager.swift
//  Demo
//
//  Created by Jason on 1/18/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit
import Alamofire
public class HTTPManager {
    //http://192.168.199.242:8080
    //http://139.129.45.31:8080
    static let HTTPURL = "http://192.168.199.242:8080"
    var request: Request!
    
    public static func POST(contentType: ContentType,params: [String: AnyObject]?) -> HTTPManager {
        let manager = HTTPManager()
        if(params != nil){
        manager.request = Alamofire.request(.POST, HTTPURL + contentType.rawValue, parameters: params, encoding: .JSON)
        }else{
            manager.request = Alamofire.request(.POST, HTTPURL + contentType.rawValue)
        }
        return manager
    }
    
    public func responseJSON(success: (json:[String: AnyObject]) -> Void, error: (error: NSError?) -> Void ){
        request.responseJSON { (response) -> Void in
            if(response.result.isSuccess){
                success(json:(response.result.value)! as! [String : AnyObject])
            }else{
                error(error: response.result.error)
            }
        }
    }
    
}
