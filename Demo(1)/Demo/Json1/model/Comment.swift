//
//  Comment.swift
//  Demo
//
//  Created by Jason on 15/12/7.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

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