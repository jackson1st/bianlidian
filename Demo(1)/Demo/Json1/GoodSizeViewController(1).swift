//
//  GoodSizeViewController.swift
//  webDemo
//
//  Created by jason on 15/11/25.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit

class GoodSizeViewController: UITableViewController {
    
    var data = [["口味","甜的","辣的","咸的","苦的","酸的"],["口味","甜的","辣的","咸的","苦的","酸的"],["口味","甜的","辣的","咸的","苦的","酸的"],["版本","64G公开版","128G国行版","16G港版","64G公开版","128G国行版","16G港版","64G公开版","128G国行版","16G港版","64G公开版","128G国行版","16G港版"],["口味","甜的","辣的","咸的","苦的","酸的"],["口味","甜的","辣的","咸的","苦的","酸的"],["口味","甜的","辣的","咸的","苦的","酸的"],["颜色","红色","黑色","白色"]]
    var prototypeCell: GoodSizeTableCell?
    var tableViewHeight:CGFloat = 20
    var viewDidAppear = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib: UINib = UINib(nibName: "GoodSizeTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "GoodSizeCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        viewDidAppear = true
         var cell = tableView.dequeueReusableCellWithIdentifier("GoodSizeCell") as! GoodSizeTableCell
        var buttons = [UIButton]()
        for(var i = 1 ; i < data[indexPath.row].count ; i++ ){
            let button = UIButton(type: .System)
            button.setTitle(data[indexPath.row][i], forState: .Normal)
            button.frame.size        = (data[indexPath.row][i] as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14.0)])
            button.setTitleColor(UIColor.blackColor() , forState: .Normal)
            button.setTitleColor(UIColor.orangeColor(), forState: .Selected)
            button.titleLabel?.font  = UIFont.systemFontOfSize(14)
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.layer.borderWidth = 0.3
            buttons.append(button)
        }
        print(indexPath.row)
        cell.sizeTag        = (indexPath.row+1)*100
        cell.buttons        = buttons
        cell.nameLabel.text = data[indexPath.row][0]
        cell.selectionStyle = .None
        print(tableView.frame)
        prototypeCell = cell
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       print("重绘了\(indexPath.row)的高度")
        if(viewDidAppear){
            print("yes")
            tableViewHeight += (prototypeCell?.contentView.frame.height)! + 1
            tableView.frame.size.height = tableViewHeight
            print((prototypeCell?.contentView.frame.height)! + 1)
            if(indexPath.row == data.count - 1 ){
                NSNotificationCenter.defaultCenter().postNotificationName("LoadEVA", object: self)
            }
            return (prototypeCell?.contentView.frame.height)! + 1
        }
        return 10
    }

    
}
