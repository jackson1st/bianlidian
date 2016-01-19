//
//  HTTPManager.swift
//  Demo
//
//  Created by Jason on 1/18/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit

public class HTTPManager {
    static let HTTPURL = "http://192.168.199.134:8080"
    var pitaya: Pitaya!
    
    
    public static func POST(contentType: ContentType,params: [String: AnyObject]) -> HTTPManager {
        let p = HTTPManager()
        let json = JSONND.init(dictionary: params)
        p.pitaya = Pitaya.build(HTTPMethod: .GET, url: HTTPURL + contentType.rawValue).setHTTPBodyRaw(json.RAWValue, isJSON: true)
        return p
    }
    
    public func responseJSON(callback: ((json: JSONND, response: NSHTTPURLResponse?) -> Void)?) {
        self.pitaya.responseJSON(callback)
    }
    
}
