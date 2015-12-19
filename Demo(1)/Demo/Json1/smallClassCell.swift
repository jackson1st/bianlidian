//
//  smallClassCell.swift
//  Demo
//
//  Created by Jason on 15/12/18.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class smallClassCell: UICollectionViewCell {

    var imgView: UIImageView!
    var textLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //初始化imgView
        imgView = UIImageView()
        self.contentView.addSubview(imgView)
        imgView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(-10)
            make.height.equalTo(20)
            make.width.equalTo(height)
        }
        
        //初始化textLabel
        textLabel = UILabel()
        textLabel.font = UIFont.systemFontOfSize(14)
        self.contentView.addSubview(textLabel)
        textLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.top.equalTo(imgView.snp_bottom).offset(5)
        }
        
    }

}
