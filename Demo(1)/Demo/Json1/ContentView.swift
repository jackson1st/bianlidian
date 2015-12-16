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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setLabel(title: String!, price: String!, sco: String!,salesNum: String!){
        LabelTItle.text = title
        LabelPrice.text = price
        LabelSco.text = sco
        LabelSalesNum.text = salesNum
        self.layoutIfNeeded()
    }
    
    
}
