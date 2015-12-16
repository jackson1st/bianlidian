//
//  GoodSizeTableCell.swift
//  webDemo
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit

class GoodSizeTableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    var sizeTag: Int?
    var chooseButtonCur: Int?
    //MARK:进行button的布局
    var buttons: [UIButton]?{
        didSet{
            //这里要完成button的布局。
            let width = buttonView.frame.width
            //用(sx,sy)是当前button应该放的位置
            var sx:CGFloat = 5,sy:CGFloat = 11
            var cur = 1
            for var button in buttons!{
                if(button.frame.width + sx > width){
                    sy = sy + button.frame.height + 5
                    sx = 5
                }
                button.tag = sizeTag! + cur
                cur++
                button.frame.origin = CGPoint(x: sx,y: sy)
                button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                buttonView.addSubview(button)
                sx += button.frame.width + 5
            }
            buttonView.frame.size.height = sy + 30
            contentView.frame.size.height = sy + 35
            self.setNeedsLayout()
        }
    }
    
    func buttonClicked(sender: AnyObject?){
        let buttonTag = (sender as! UIButton).tag
        for var button in buttons!{
            if(button.tag != buttonTag){
                button.selected = false
            }else{
                if(button.selected != true){
                    button.selected = true
                    chooseButtonCur = buttonTag - sizeTag!
                }else{
                    button.selected = false
                    chooseButtonCur = -1
                }
                
            }
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
