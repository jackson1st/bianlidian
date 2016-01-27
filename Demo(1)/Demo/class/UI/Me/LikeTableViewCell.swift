//
//  LikeTableViewCell.swift
//  Demo
//
//  Created by Jason on 1/27/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var TextLabelTitle: UILabel!
    @IBOutlet weak var TextLabelPrice: UILabel!
    var model: LikedModel!{
        didSet{
            img.setImageWithURL(NSURL(string: model.url)!)
            img.sizeToFit()
            TextLabelTitle.text = model.name
            TextLabelPrice.text = "￥ " + "\(model.price)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius = 3
        img.layer.borderColor = UIColor.lightGrayColor().CGColor
        img.layer.borderWidth = 0.1
        self.backgroundColor = UIColor.colorWith(248, green: 248, blue: 248, alpha: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
