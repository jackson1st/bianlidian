//
//  UIView+.swift
//  Demo
//
//  Created by jason on 1/28/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import Foundation

extension UIView{
    
    /**
     在view的底部加一条线
     
     - parameter height:      线的厚度
     - parameter offsetLeft:  到左端的距离，大于等于0有效
     - parameter offsetRight: 到右端的距离，小于等于0有效
     */
    func addBottomLine(height: CGFloat,offsetLeft:CGFloat,offsetRight:CGFloat){
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(view)
        view.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(height)
            make.left.equalTo(self).offset(offsetLeft)
            make.right.equalTo(self).offset(offsetRight)
            make.bottom.equalTo(self).offset(-0.5)
        }
    }
    
    
    /**
     在view的顶部加一条线
     
     - parameter height:      线的厚度
     - parameter offsetLeft:  到左端的距离，大于等于0有效
     - parameter offsetRight: 到右端的距离，小于等于0有效
     */
    func addTopLine(height: CGFloat,offsetLeft:CGFloat,offsetRight:CGFloat){
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(view)
        view.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(height)
            make.left.equalTo(self).offset(offsetLeft)
            make.right.equalTo(self).offset(offsetRight)
            make.top.equalTo(self)
        }
    }
}