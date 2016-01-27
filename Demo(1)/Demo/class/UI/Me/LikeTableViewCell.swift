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
    var model: LikedModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        img.setImageWithURL(NSURL(string: model.url)!)
        TextLabelTitle.text = model.name
        TextLabelPrice.text = "￥ " + "\(model.price)"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
