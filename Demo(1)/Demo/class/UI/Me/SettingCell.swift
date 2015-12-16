//
//  SettingCell.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/19.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

import UIKit

enum SettingCellType: Int {
    case Recommend = 0
    case About = 1
    case Clean = 2
}

class SettingCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.alpha = 0.3
        sizeLabel.hidden = true
        selectionStyle = .None
    }

    class func settingCellWithTableView(tableView: UITableView) -> SettingCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell") as! SettingCell
        return cell
    }

}
