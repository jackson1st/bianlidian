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
    static let HTTPURL2 = "http://139.129.45.31:8080"
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
        
//        Alamofire.upload(.POST, HTTPURL + contentType.rawValue, headers: params as! [String: String], data: NSData(contentsOfURL: NSURL(string: SD_UserIconData_Path)!)!).responseJSON { (response) -> Void in
//            print(response)
//        }
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

//let manager = AFHTTPRequestOperationManager()
//manager.requestSerializer = AFHTTPRequestSerializer()
//manager.responseSerializer = AFHTTPResponseSerializer()
//let parameter: [String : String] = ["custno" : UserAccountTool.userCustNo()!]
//let url = "\(HTTPManager.HTTPURL)/BSMD/userHeadPicSubmit.do"
//
//manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
//manager.POST(url, parameters: parameter, constructingBodyWithBlock: { (formData) -> Void in
//    
//    try! formData.appendPartWithFileURL(NSURL(fileURLWithPath: SD_UserIconData_Path), name: "image.data")
//    }, success: { (opertion, response) -> Void in
//        SVProgressHUD.showSuccessWithStatus("图片上传成功", maskType: SVProgressHUDMaskType.Black)
//    }, failure: { (opertion, error) -> Void in
//        SVProgressHUD.showErrorWithStatus("图片上传失败", maskType: SVProgressHUDMaskType.Black)
//})
//iconView!.iconButton.setImage(UIImage(data: NSData(contentsOfFile: SD_UserIconData_Path)!)!.imageClipOvalImage(), forState: .Normal)
//
//} else {
//    SVProgressHUD.showErrorWithStatus("照片保存失败", maskType: SVProgressHUDMaskType.Black)
//}
