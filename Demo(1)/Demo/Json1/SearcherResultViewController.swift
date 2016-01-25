//
//  SearcherResultViewController.swift
//  Demo
//
//  Created by jason on 15/12/10.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class SearcherResultViewController: SearcherViewController {

    var ViewChooseType: UIView!
    var keyForSearchResult: String!{
        didSet{
            HTTPManager.POST(ContentType.SearchResultListByItemName, params: ["address": address, "itemname": keyForSearchResult]).responseJSON({ (json) -> Void in
                print(json)
                self.data.removeAll()
                var Json = json["itemlist"] as! NSDictionary
                let arr = Json["list"] as! [NSDictionary]
                for var x in arr{
                    self.data.append(SearchItemResult(no: x["itemNo"] as? String,name: x["itemName"] as? String, itemByNum: x["itemBynum1"] as? String, price: x["itemSalePrice"] as? String, brandName: x["brandName"] as? String, eshopIntergral: x["eshopIntegral"] as? Double, url: x["url"] as? String))
                }
                self.tableView.reloadData()
                }) { (error) -> Void in
                    print("发生了错误: " + (error?.localizedDescription)!)
            }
            
        }
    }
    var data = [SearchItemResult]()
    var item: GoodDetail?
    var tableView: UITableView!
    
    //排序
    var orderstyle: Bool?
    var ordercondition: String?
    var pageindex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAll2()
        self.view.backgroundColor = UIColor.colorWith(243, green: 241, blue: 244, alpha: 1)
        self.view.bringSubviewToFront(MainView)
        showSuperView(true)
    }
    
    deinit{
        print("我要被销毁了")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSuperView(show:Bool){
        MainView.hidden = show
    }
    
    func ButtonTypeClicked(sender: AnyObject){
        print(sender.tag)
        data.removeAll()
        switch(sender.tag){
        case 102:
            if(ordercondition == "item_bynum1"){
                if(orderstyle == false){
                    orderstyle = true
                }else{
                    orderstyle = false
                }
            }else{
                ordercondition = "item_bynum1"
                orderstyle = true
            }
        case 103:
            if(ordercondition == "item_sale_price"){
                if(orderstyle == false){
                    orderstyle = true
                }else{
                    orderstyle = false
                }
            }else{
                ordercondition = "item_bynum1"
                orderstyle = true
            }
        default:
            ordercondition = "none"
        }
        loadData()
    }
    
}

// MARK: - 一些操作方法
extension SearcherResultViewController{
    
    func loadData(){
        if(ordercondition == "none"){
            
            HTTPManager.POST(ContentType.SearchResultListByItemName, params: ["address": address, "itemname": keyForSearchResult]).responseJSON({ (json) -> Void in
                print(json)
                var Json = json["itemlist"] as! NSDictionary
                let arr = Json["list"] as! [NSDictionary]
                for var x in arr{
                    self.data.append(SearchItemResult(no: x["itemNo"] as? String,name: x["itemName"] as? String, itemByNum: x["itemBynum1"] as? String, price: x["itemSalePrice"] as? String, brandName: x["brandName"] as? String, eshopIntergral: x["eshopIntegral"] as? Double, url: x["url"] as? String))
                }
                self.tableView.reloadData()
                }) { (error) -> Void in
                    print("发生了错误: " + (error?.localizedDescription)!)
            }
            

        }else{
            
            HTTPManager.POST(ContentType.SearchResultListByItemName, params: ["address": address, "name": keyForSearchResult, "pageindex": "1","pagecount":"10","ordercondition": ordercondition!, "orderstyle": orderstyle == true ? "asc" : "desc"]).responseJSON({ (json) -> Void in
                let arr = (json["itemlist"] as! NSDictionary)["list"] as! [NSDictionary]
                print(arr)
                for var x in arr{
                    self.data.append(SearchItemResult(no: x["itemNo"] as? String,name: x["itemName"] as? String, itemByNum: x["itemBynum1"] as? String, price: x["itemSalePrice"] as? String, brandName: x["brandName"] as? String, eshopIntergral: x["eshopIntegral"] as? Double, url: x["url"] as? String))
                }
                self.tableView.reloadData()
                }, error: { (error) -> Void in
                    print("发生了错误: " + (error?.localizedDescription)!)
            })
            
        }
    }
}
// MARK: - SearchkeyViewControllerDelegate
extension SearcherResultViewController{
    override func TheKeyGoToResultViewController(key: String) {
        if(history.contains(key) == true){
            history.removeAtIndex(history.indexOf(key)!)
        }
        history.insert(key, atIndex: 0)
        searchvc.searchBar.text = key
        keyForSearchResult = key
        searchvc.active = false
        searchvc.searchBar.resignFirstResponder()
    }
}

//MARK:- 一些初始化
extension SearcherResultViewController{
    
     func initAll2(){
        initViewChooseType()
        initTabelView()
    }
    
    func initViewChooseType(){
        ViewChooseType = UIView()
        view.addSubview(ViewChooseType)
        ViewChooseType.translatesAutoresizingMaskIntoConstraints = false
        ViewChooseType.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(64)
            make.left.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(30)
        }
        ViewChooseType.backgroundColor = UIColor.whiteColor()
        ViewChooseType.layoutIfNeeded()
        //ViewChooseType.backgroundColor = UIColor.blackColor()
        let width = ViewChooseType.width/4
        var button1 = UIButton()
        button1.setTitle("全部", forState: .Normal)
        button1.setTitleColor(UIColor.blackColor(), forState: .Normal)
       // button1.setTitleColor(UIColor.colorWith(245, green: 77, blue: 86, alpha: 1), forState: .Selected)
        var view1 = UIView()
        button1.addSubview(view1)
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.backgroundColor = UIColor.blackColor()
        view1.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(button1)
            make.right.equalTo(button1)
            make.width.equalTo(1)
            make.centerY.equalTo(button1)
        }
        ViewChooseType.addSubview(button1)
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(width)
            make.height.equalTo(20)
            make.left.equalTo(ViewChooseType)
            make.centerY.equalTo(ViewChooseType)
        }
        button1.tag = 101
        button1.addTarget(self, action: "ButtonTypeClicked:", forControlEvents: .TouchUpInside)
        
        var button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.setTitle("销量", forState: .Normal)
        button2.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button2.setTitleColor(UIColor.colorWith(245, green: 77, blue: 86, alpha: 1), forState: .Selected)
        var view2 = UIView()
        button2.addSubview(view2)
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.backgroundColor = UIColor.blackColor()
        view2.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(button2)
            make.right.equalTo(button2)
            make.width.equalTo(1)
            make.centerY.equalTo(button2)
        }
        ViewChooseType.addSubview(button2)
        button2.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(width)
            make.height.equalTo(20)
            make.left.equalTo(button1.snp_right)
            make.centerY.equalTo(ViewChooseType)
        }
        button2.tag = 102
        button2.addTarget(self, action: "ButtonTypeClicked:", forControlEvents: .TouchUpInside)
        
        var button3 = UIButton()
        button3.translatesAutoresizingMaskIntoConstraints = false
        button3.setTitle("价格", forState: .Normal)
        button3.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button3.setTitleColor(UIColor.colorWith(245, green: 77, blue: 86, alpha: 1), forState: .Selected)
        var view3 = UIView()
        button3.addSubview(view3)
        view3.translatesAutoresizingMaskIntoConstraints = false
        view3.backgroundColor = UIColor.blackColor()
        view3.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(button3)
            make.right.equalTo(button3)
            make.width.equalTo(1)
            make.centerY.equalTo(button3)
        }
        ViewChooseType.addSubview(button3)
        button3.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(width)
            make.height.equalTo(20)
            make.left.equalTo(button2.snp_right)
            make.centerY.equalTo(ViewChooseType)
        }
        button3.tag = 103
        button3.addTarget(self, action: "ButtonTypeClicked:", forControlEvents: .TouchUpInside)
        
        var button4 = UIButton()
        button4.translatesAutoresizingMaskIntoConstraints = false
        button4.setTitle("店铺", forState: .Normal)
        button4.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button4.setTitleColor(UIColor.colorWith(245, green: 77, blue: 86, alpha: 1), forState: .Selected)
        var view4 = UIView()
        button4.addSubview(view4)
        view4.translatesAutoresizingMaskIntoConstraints = false
        view4.backgroundColor = UIColor.blackColor()
        view4.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(button4)
            make.right.equalTo(button4)
            make.centerY.equalTo(button4)
            make.width.equalTo(1)
        }
        ViewChooseType.addSubview(button4)
        button4.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(width)
            make.height.equalTo(20)
            make.left.equalTo(button3.snp_right)
            make.centerY.equalTo(ViewChooseType)
        }
        button4.tag = 104
        button4.addTarget(self, action: "ButtonTypeClicked:", forControlEvents: .TouchUpInside)
    }
    
    func initTabelView(){
        tableView = UITableView()
        tableView.tag = 101
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: "IitemSearchResultViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(ViewChooseType.snp_bottom)
            make.left.equalTo(view)
            make.width.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension SearcherResultViewController{
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        showSuperView(false)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        showSuperView(true)
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension SearcherResultViewController{
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 101){
            return data.count
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView.tag == 101){
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! IitemSearchResultViewCell
            cell.data = data[indexPath.row]
            print(indexPath.row)
            return cell
        }else{
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    //数据的请求写到对应的页面较好，之后完善
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("yes")
        
        if(tableView.tag == 101){
            let itemno = data[indexPath.row].No
            let json: JSONND = ["itemno":itemno!,"address":address!]
            
            /**
            *  获取商品详情
            *
            *  @param ContentType.ItemDetail 地址
            *  @param
            *  @param "address":address!]    json数组
            *
            *  @return 无
            */
            HTTPManager.POST(ContentType.ItemDetail, params: ["itemno":itemno!,"address":address!]).responseJSON({ (json) -> Void in
                let dict = json["detail"] as! [String: AnyObject]
                print(dict)
                self.item = GoodDetail()
                var arry = json["comment"] as? NSArray
                self.item?.comments = [Comment]()
                for var x in arry!{
                    var xx = x as! [String: AnyObject]
                    self.item?.comments?.append(Comment(content: xx["comment"] as? String, date: xx["commentDate"] as? String, userName: xx["custNo"] as? String))
                }
                self.item?.eshopIntegral = dict["eshopIntegral"] as! Int
                self.item?.itemBynum1 = dict["itemBynum1"] as! String
                self.item?.itemName = dict["itemName"] as! String
                self.item?.itemNo = dict["itemNo"] as! String
                self.item?.itemSalePrice = dict["itemSalePrice"] as! String
                arry = json["stocks"] as! NSArray
                self.item?.itemStocks = [ItemStock]()
                for var x in arry!{
                    var xx = x as! [String: AnyObject]
                    self.item?.itemStocks.append(ItemStock(name: xx["shopName"] as? String, qty: (xx["stockQty"] as? Int)))
                }
                
                arry = dict["itemUnits"] as! NSArray
                print(arry)
                self.item?.itemUnits = [ItemUnit]()
                for var x in arry!{
                    var xx = x as! [String: AnyObject]
                    self.item?.itemUnits.append(ItemUnit(salePrice: xx["itemSalePrice"] as? String , sizeName: xx["itemSize"] as? String))
                }
                self.item?.imageDetail = json["imageDetail"] as! [String]
                self.item?.imageTop = json["imageTop"] as! [String]
                
                let vc = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("itemDetail") as! OtherViewController
                vc.item = self.item
                //self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationController?.pushViewController(vc, animated: true)
                }) { (error) -> Void in
                    print("发生了错误: " + (error?.localizedDescription)!)
            }
        }else{
            super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        }
        
    }
}
