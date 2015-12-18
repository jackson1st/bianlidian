//
//  SortModel.swift
//  Demo
//
//  Created by Jason on 15/12/18.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class smallClass: NSObject {

    var name: String?
    var url: String?
    var id: String?
    override init(){
        super.init()
        name = "无"
        url = "无"
        id = "无"
    }
    
    convenience init(name: String?,url: String?,id: String?){
        self.init()
        self.name = name
        self.url = url
        self.id = id
    }
}
