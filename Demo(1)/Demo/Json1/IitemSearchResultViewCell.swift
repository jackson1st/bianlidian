//
//  IitemSearchResultViewCell.swift
//  Demo
//
//  Created by jason on 15/12/10.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class IitemSearchResultViewCell: UITableViewCell {
    @IBOutlet weak var ImgViewPhoto: UIImageView!
    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var LabelPrice: UILabel!
    @IBOutlet weak var LabelSaleNum: UILabel!
    
    var data: SearchItemResult?{
        didSet{
            ImgViewPhoto.setImageWithURL(NSURL(string: data!.imgurl!))
            LabelTitle.text = (data?.brandName)! + "  " + (data?.name)!
            LabelTitle.sizeToFit()
            LabelPrice.text = data?.price
            LabelPrice.sizeToFit()
            LabelSaleNum.text = data?.saleNum
            LabelSaleNum.sizeToFit()
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
