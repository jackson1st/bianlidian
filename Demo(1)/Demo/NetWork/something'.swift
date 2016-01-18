//
//  something'.swift
//  Demo
//
//  Created by Jason on 1/18/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import Foundation


/*
搜索内容

1、获取搜索的关键字
地址：http://192.168.43.185:8080/BSMD/item/findlist
发送格式(key)：地址：address    关键字的名字: name
返回格式(key)：关键字名字:name

2、获取搜索结果列表
地址：http://192.168.43.185:8080/BSMD/item/search
发送格式(key)：地址：address    关键字的名字: name
返回格式(key)：商品（数组）列表:itemlist
商品字段：商品编号：itemNo    商品名字:itemName   购买人数：itemBynum1 商品价格：itemSalePrice
        名牌名称：brandName  商品图片地址: url   eshopIntegral：eshopIntegral


3、获取搜索结果列表（排序后）
地址：http://192.168.43.185:8080/BSMD/item/search
发送格式(key)：地址：address    关键字的名字: name    开始页：pageindex   请求的页数：pagecount
             排序的类别：ordercondition
             类别字段：
                    按销量：item_bynum1     
返回格式(key)：商品（数组）列表:itemlist
*/