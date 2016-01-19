//
//  ContentType.swift
//  Demo
//
//  Created by Jason on 1/18/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import Foundation

public enum ContentType: String{

    /**
     *  购物车相关
     */
    //将商品加入购物车
    case PushItemToCar = "/BSMD/car/addToCar.do"
    //显示购物车
    case ShowCarDetail = "/BSMD/car/showCar.do"
    //从购物车删除
    case DelFromCar = "/BSMD/car/deletFromCar.do"
    //结算
    case CalMoney = "/BSMD/car/settlement.do"
    //判断是否超过库存
    case IsOverStock = "/BSMD/car/isOverStock"
    //更新购物车中商品数量
    case UpdateItemNum = "/BSMD/car/updateItemNum"
    //计算购物车数量
    case calItemNum = "/BSMD/car/countItemNum"
    
    /**
     *  主页相关
     */
    //获取主页网页信息
    case WebData = "/BSMD/main.do"
    
    
    /**
     *  商品相关
     */
    //获取商品详情
    case ItemDetail = "/BSMD/item/detail.do"
    //获取商品评论
    case ItemComment = "/BSMD/item/comment.do"
    //获取分类列表
    case ItemBigClass = "/BSMD/item/getclass.do"
    //获取类别表
    case ItemSmallClass = "/BSMD/item/classlist.do"
    //获取搜索列表
    case SearchResultList = "/BSMD/item/findlist.do"
    
    
    /**
     *  定位相关
     */
    case Location = "/BSMD/locate/city.do"
    
    /**
     *  登陆相关
     */
    //网页登陆
    case WebLogin = "/BSMD/login.do"
    //手机登陆
    case LoginMobile = "/BSMD/loginMobile.do"
    //更改手机号
    case updateTel = "/BSMD/updateTel.do"
    //更改密码
    case updateUserPWD = "/BSMD/updatePassword.do"
    //手机退出
    case logoutMobile = "/BSMD/logoutMobile.do"
    //退出
    case logut = "/BSMD/logout"
    
    
    /**
     *  订单相关
     */
    //查询用户订单
    case UserOrder = "/BSMD/order/select/list.do"
    //查询店铺订单
    case ShopOrder = "/BSMD/order/select/shop.do"
    //查询订单详情
    case OrderDetail = "/BSMD/order/select/info.do"
    //添加订单
    case OrderAdd = "/BSMD/order/insert.do"
    //更新订单
    case OrderUpdate = "/BSMD/order/update.do"
    
    
    /**
     *  退货相关
     */
    //退货业务
    case RefundApply = "/BSMD/refund/apply"
    
    /**
     *  注册相关
     */
    //手机注册
    case Register = "/BSMD/registerMobile.do"
    //激活
    case UserActivation = "/BSMD/activation.do"
    
    
    /**
     *  用户地址相关
     */
    //获取用户地址列表
    case UserAddress = "/BSMD/getUserAddress.do"
    //添加用户地址
    case AddAddress = "/BSMD/insertUserAddress.do"
    //修改用户地址
    case ModifyAddress = "/BSMD/updateUserAddress.do"
    //设置默认地址
    case ModifyDefaultAddress = "/BSMD/updateDefaultAddress.do"
    //取消默认地址
    case cancelDefaultAddress = "/BSMD/deleteDefaultAddress.do"
    //删除用户地址
    case deleteAddress = "/BSMD/deleteUserAddress.do"
    
    /**
    *  用户收藏相关
    */
    //获取用户收藏
    case CollectionGet = "/BSMD/getUserCollection.do"
    //删除收藏
    case CollectionDelete = "/BSMD/deleteCollection.do"
    //添加收藏
    case CollectionAdd = "/BSMD/insertCollection.do"
    
    /**
    *  用户头像相关
    */
    
    
    /**
    *  积分相关
    */
    //获取用户积分
    case IntGet = "/BSMD/getUserIntegral.do"
    //更改用户积分
    case IntModify = "/BSMD/updateUserIntegral.do"
    
    /**
    *  礼卷相关
    */
    //获取用户礼卷
    case StampGet = "/BSMD/getUserPosStamp.do"
    //

}