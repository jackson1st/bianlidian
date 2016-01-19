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
                    按价格：item_sale_price
                    综合排序: none
             升降序类别：orderstyle   asc or desc
返回格式(key)：商品（数组）列表:itemlist
商品字段：商品编号：itemNo    商品名字:itemName   购买人数：itemBynum1 商品价格：itemSalePrice
名牌名称：brandName  商品图片地址: url   eshopIntegral：eshopIntegral

4、获取商品详情
地址：http://192.168.199.242:8080/BSMD/item/detail.do
发送格式(key)：地址：address    关键字的名字: name
返回格式(key)：详情集合名称：detail
              相关字段：eshopIntegral    itemBynum1  itemName    itemNo  itemSalePrice
            评论名称：comment
              相关字段：comment  commentDate     custNo
            店铺名称：stock
              店铺名称：shopName     stockQty
            商品类别：itemUnits
              相关字段：itemSalePrice    itemSize
            商品详情图片：imageDetail（图片组合）
            浏览图片：   imageTop（图片组合）



定位相关
地址：http://192.168.43.185:8080/BSMD/locate/city.do
发送格式(key)：城市1：city    城市2: county   （Null表示空）
返回格式(key)：citys     countys    shops

主页加载商品详情
地址：http://192.168.43.185:8080/BSMD/item/detail.do
发送格式(key)：商品编号：itemno    地区: address
返回格式(key)：detail    comment


分类

获取页面初始分类数据
地址：http://192.168.43.185:8080/BSMD/item/classlist.do
发送格式：空

获取collectionView数据
地址：http://192.168.43.185:8080/BSMD222/item/getclass.do
发送格式(key)：大类名称：name

获取订单信息（CenterController）
地址：http://192.168.199.134:8080/BSMD/order/select/shop
发送格式(key)：编号：No     开始页面：pageIndex  页面数量：pageCount  订单状态：orderStatu

获取订单详情（OrderController）
地址：http://192.168.199.149:8080/BSMD/order/update
发送格式(key)：编号：No     订单编号：orderNo    订单状态：orderStatu

登陆（LoginViewController）
地址：http://192.168.199.233:8080/BSMD/loginMobile.do
发送格式(key)：用户名：username  密码：password


提交一个新订单(PayViewController)
地址：http://192.168.43.185:8080/BSMD/order/insert
发送格式(key)：





*/