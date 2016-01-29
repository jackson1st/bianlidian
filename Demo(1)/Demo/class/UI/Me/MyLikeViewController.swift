//
//  MyLikeViewController.swift
//  Demo
//
//  Created by Jason on 1/27/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit

class MyLikeViewController: UITableViewController {

    var index = 1
    var count = 10
    var Likes: [LikedModel]?
    var itemVC: OtherViewController?
    var address: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefault = NSUserDefaults.standardUserDefaults()
        address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
        initAll()
        tableView.backgroundColor = UIColor.colorWith(245, green: 245, blue: 245, alpha: 1)
        navigationItem.title = "我的收藏"
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(Likes == nil){
            CollectionModel.CollectionCenter.loadDataFromNet(index, count: count, success: nil, callback: { () -> Void in
                self.index++
                self.Likes =  CollectionModel.CollectionCenter.Likes
                self.tableView.reloadData()
            })
            return 0
        }else{
            return Likes!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! LikeTableViewCell
        cell.model = Likes![indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(itemVC == nil){
            itemVC = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("itemDetail") as! OtherViewController
            itemVC?.address = address
        }
        itemVC?.itemNo = Likes![indexPath.row].no
        self.navigationController?.pushViewController(itemVC!, animated: true)
    }
}
extension MyLikeViewController{
    
    func initAll(){
        initHeaderRefresh()
        initFootRefresh()
        initTableview()
    }
    
    func initTableview(){
        tableView.registerNib(UINib(nibName: "LikeTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "cell")
        tableView.rowHeight = 103
    }
    
    func initHeaderRefresh(){
        tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.getNewData({ () -> Void in
                self.tableView.header.endRefreshing()
                self.tableView.reloadData()
            })
            
        })
    }
    
    func getNewData(callback: (() -> Void)){
        CollectionModel.CollectionCenter.loadDataFromNet(1, count: 100, success: { (data) -> Void in
            
            let model:LikedModel!
            if(self.Likes!.count>0){
                model = self.Likes![0]
            }else{
                model = LikedModel(No: "-1", price: nil, name: "xx", url: "xx", unitNo: nil, size: nil, pack: nil)
            }
            
            for(var i = 0;i < data.count;i++){
                if(data[i].no == model.no){
                    break
                }else{
                    self.Likes!.insert(data[i], atIndex: i)
                }
            }
            var i = 0
            for var x in self.Likes!{
                CollectionModel.CollectionCenter.dict[x.no] = i
                i++
            }
            }) { () -> Void in
                callback()
        }
    }
    
    func initFootRefresh(){
        tableView.footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadNetData({ () -> Void in
                self.index++
                self.tableView.footer.endRefreshing()
                self.tableView.reloadData()
            })
        })
        
        //清楚多余的线
        let iview = UIView()
        iview.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = iview
    }
    
    func loadNetData(callback: () -> Void){
        CollectionModel.CollectionCenter.loadDataFromNet(index, count: count, success: { (data) -> Void in
            if(data.count == 0){
                SVProgressHUD.showInfoWithStatus("已经没有更多数据了")
            }
            for var x in data{
                CollectionModel.CollectionCenter.dict[x.no] = self.Likes!.count
                self.Likes!.append(x)
            }
            }) { () -> Void in
                callback()
        }
        
    }
    
}
