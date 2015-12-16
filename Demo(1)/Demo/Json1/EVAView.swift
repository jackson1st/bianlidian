//
//  EVAView.swift
//  Demo
//
//  Created by Jason on 15/12/7.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class EVAView: UIView {
    
    var LabelDate: UILabel!
    var LabelContent: UILabel!
    var LabelUser: UILabel!
    
    
    convenience init(var frame: CGRect!, date: String!, content: String!,user: String!){
        self.init()
        backgroundColor = UIColor.whiteColor()
        LabelDate = UILabel()
        addSubview(LabelDate)
        LabelContent = UILabel()
        LabelContent.numberOfLines = 2
        addSubview(LabelContent)
        LabelUser = UILabel()
        addSubview(LabelUser)
        let view = UIView(frame: CGRect(x: 20, y: frame.height - 1, width: frame.width - 40, height: 1))
        view.backgroundColor = UIColor.blackColor()
        addSubview(view)
        
        
        LabelDate.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_top).offset(5)
            make.left.equalTo(self.snp_left).offset(20)
        }
        LabelContent.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(LabelDate.snp_bottom).offset(5)
            make.left.equalTo(self.snp_left).offset(10)
        }
        LabelUser.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_top).offset(10)
            make.right.equalTo(self.snp_right).offset(-20)
        }
        LabelContent.layoutIfNeeded()
        self.frame = frame
        setLabel(date, content: content, user: user)
    }
    
    private func setLabel(date: String!, content: String!,user: String!){
        
        LabelDate.text = date
        LabelContent.text = content
        LabelUser.text = user
    }

}
