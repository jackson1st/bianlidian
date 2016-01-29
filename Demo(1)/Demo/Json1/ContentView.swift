//
//  ContentView.swift
//  Demo
//
//  Created by jason on 15/12/7.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class ContentView: UIView {
    
    @IBOutlet weak var LabelTItle: UILabel!
    @IBOutlet weak var LabelPrice: UILabel!
    @IBOutlet weak var LabelSco: UILabel!
    @IBOutlet weak var LabelSalesNum: UILabel!
    var labelX: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    func initLabel(){
        LabelTItle = UILabel()
        LabelPrice = UILabel()
        LabelSco = UILabel()
        LabelSalesNum = UILabel()
        labelX = UILabel()
        self.addSubview(LabelTItle)
        self.addSubview(LabelPrice)
        self.addSubview(LabelSco)
        self.addSubview(LabelSalesNum)
        self.addSubview(labelX)
        //添加约束
        LabelTItle.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(5)
            make.top.equalTo(self).offset(5)
        }
        LabelTItle.numberOfLines = 2
        LabelTItle.font = UIFont.systemFontOfSize(16)
        
        labelX.text = "￥"
        labelX.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self).offset(-5)
            make.left.equalTo(self).offset(5)
            make.width.equalTo(5)
            make.height.equalTo(5)
        }
        labelX.font = UIFont.systemFontOfSize(15)
        
        LabelPrice.textColor = UIColor.redColor()
        LabelPrice.font = UIFont.systemFontOfSize(16)
        LabelPrice.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(labelX).offset(2)
            make.bottom.equalTo(labelX)
        }
        
        LabelSco.font = UIFont.systemFontOfSize(15)
        LabelSco.textColor = UIColor.redColor()
        LabelSco.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.bottom.equalTo(labelX)
        }
        
        LabelSalesNum.textColor = UIColor.lightGrayColor()
        LabelSalesNum.font = UIFont.systemFontOfSize(15)
        LabelSalesNum.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(labelX)
        }
    }
    
    func setLabel(title: String!, price: String!, sco: String!,salesNum: String!){
        LabelTItle.text = title
        LabelPrice.text = "￥" + price
        LabelSco.text = sco
        LabelSalesNum.text = salesNum + "人购买"
        self.layoutIfNeeded()
    }
    
    
}
