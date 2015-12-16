//
//  EVAViewController.swift
//  webDemo
//
//  Created by jason on 15/11/24.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit

class EVAViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var HeadView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var sumOfEVA: UILabel!
    var numberOfEVA = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        sumOfEVA.text = "商品评价(111)"
        tableview.bounces = false
        tableview.frame.size.height = 0
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.lightGrayColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:-实现数据方法
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfEVA
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("cell") as! EVATableViewCell
        cell.dataLabel.text = "2015/11/24 14:30:30"
        cell.contentLabel.text = "好"
        cell.personLabel.text = "admin"
        cell.selectionStyle = .None
        tableViewHeight.constant += cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
        self.view.frame.size.height = tableViewHeight.constant + 40
        return cell
    }

    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vv = UIButton(frame: CGRect(x: (self.view.frame.width-100)/2, y: 5, width: 100, height: 18))
        vv.setTitle("点击加载更多", forState: UIControlState.Normal)
        vv.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        vv.addTarget(self, action: "addMoreEVA", forControlEvents: UIControlEvents.TouchUpInside)
        return vv
    }
    func addMoreEVA(){
        print("加载")
        numberOfEVA+=10
        tableview.reloadData()
        tableViewHeight.constant+=10*10
        view.frame.size.height += 10*10
        NSNotificationCenter.defaultCenter().postNotificationName("addMoreEVA", object: nil)
    }
    
    //MARK:-

   }
