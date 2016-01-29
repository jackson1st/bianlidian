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
    var findByClass:Bool = false
    var index = 1
    var count = 20
    var keyForSearchResult: String!{
        didSet{
            ordercondition = "none"
            loadData()
        }
    }
    var data = [SearchItemResult]()
    var item: GoodDetail?
    var tableView: UITableView!
    
    //排序
    var orderstyle: Bool?
    var ordercondition: String?
    var pageindex = 0
    var button1,button2,button3:UIButton!
    var arrowLabel: UILabel!
    
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
        data.removeAll()
        switch(sender.tag){
        case 102:
            button1.selected = false
            button2.selected = true
            button3.selected = false
            button3.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            arrowLabel.textColor = UIColor.lightGrayColor()
            ordercondition = "item_bynum1"
            orderstyle = false
        case 103:
            if(button3.selected == false){
                button1.selected = false
                button2.selected = false
                button3.selected = true
            }
            if(ordercondition == "item_sale_price"){
                if(orderstyle == false){
                    orderstyle = true
                }else{
                    orderstyle = false
                }
            let transform = CGAffineTransformRotate(arrowLabel.transform, CGFloat(M_PI))
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.arrowLabel.transform = transform
                })
                
            }else{
                ordercondition = "item_sale_price"
                orderstyle = true
                button3.setTitleColor(UIColor.colorWith(245, green: 77, blue: 86, alpha: 1), forState: .Normal)
                arrowLabel.textColor = UIColor.colorWith(245, green: 77, blue: 86, alpha: 1)
            }
        default:
            button1.selected = true
            button2.selected = false
            button3.selected = false
            button3.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            arrowLabel.textColor = UIColor.lightGrayColor()
            ordercondition = "none"
        }
        loadData()
    }
    
}

// MARK: - 数据相关操作
extension SearcherResultViewController{
    
    /**
    请求销量或者价格排序的数据
    
    - parameter index:   开始的页数
    - parameter count:   请求多少个
    - parameter success: 回调
    */
    func loadData(index: Int,count:Int,success:(data:[SearchItemResult]) -> Void){
        
        let parameter1 = ["address": address, findByClass ? "propertyname":"itemname": keyForSearchResult, "pageindex":index,"pagecount":count,"ordercondition": ordercondition!, "orderstyle": orderstyle == true ? "asc" : "desc"] as  [String: AnyObject]
        let parameter2 = ["address": address, findByClass ? "propertyname":"itemname": keyForSearchResult, "pageindex":index,"pagecount":count] as [String: AnyObject]
        HTTPManager.POST(ContentType.SearchResultListByItemName, params: self.ordercondition == "none" ? parameter2 : parameter1).responseJSON({ (json) -> Void in
            print(json)
            
            var data = [SearchItemResult]()
            let Json = json["itemlist"] as! NSDictionary
            let arr = Json["list"] as! [NSDictionary]
            let size = Json["pageSize"] as! Int
            if(index <= size){
                self.index = index
                for var x in arr{
                    data.append(SearchItemResult(no: x["itemNo"] as? String,name: x["itemName"] as? String, itemByNum: x["itemBynum1"] as? String, price: x["itemSalePrice"] as? String, brandName: x["brandName"] as? String, eshopIntergral: x["eshopIntegral"] as? Double, url: x["url"] as? String))
                }
            }
            success(data: data)
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
    }
    
}

// MARK: - 一些操作方法
extension SearcherResultViewController{
    
    func loadData(){
        loadData(1, count: 20, success: { (data) -> Void in
            self.data = data
            self.tableView.reloadData()
        })
    }
    
    /**
     上拉或点击加载更多方法
     
     - parameter index:   页标
     - parameter count:   请求的条数
     - parameter success: 成功的回调
     - parameter failure: 失败的回调
     */
    func getMoreData(index: Int,count:Int,success:(data:[SearchItemResult]) -> Void,failure:()->Void){
        loadData(index + 1, count: count) { (data) -> Void in
            if(data.count == 0){
                failure()
            }else{
                success(data:data)
            }
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
            make.height.equalTo(40)
        }
        ViewChooseType.backgroundColor = UIColor.whiteColor()
        ViewChooseType.layoutIfNeeded()
        let width = ViewChooseType.width/3
         button1 = UIButton()
        button1.setTitle("综合", forState: .Normal)
        button1.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        button1.setTitleColor(UIColor.colorWith(245, green: 77, blue: 86, alpha: 1), forState: .Selected)
        button1.selected = true
        let view1 = UIView()
        button1.addSubview(view1)
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.backgroundColor = UIColor.lightGrayColor()
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
        
         button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.setTitle("销量", forState: .Normal)
        button2.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        button2.setTitleColor(UIColor.colorWith(245, green: 77, blue: 86, alpha: 1), forState: .Selected)
        let view2 = UIView()
        button2.addSubview(view2)
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.backgroundColor = UIColor.lightGrayColor()
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
        
         button3 = UIButton()
        button3.translatesAutoresizingMaskIntoConstraints = false
        button3.setTitle("价格", forState: .Normal)
        button3.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        button3.setTitleColor(UIColor.colorWith(245, green: 77, blue: 86, alpha: 1), forState: .Selected)
        ViewChooseType.addSubview(button3)
        button3.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(width)
            make.height.equalTo(20)
            make.left.equalTo(button2.snp_right)
            make.centerY.equalTo(ViewChooseType)
        }
        button3.tag = 103
        button3.addTarget(self, action: "ButtonTypeClicked:", forControlEvents: .TouchUpInside)
        arrowLabel = UILabel()
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.text = "▲"
        arrowLabel.textColor = UIColor.lightGrayColor()
        arrowLabel.textAlignment = .Center
        arrowLabel.font = UIFont.systemFontOfSize(8)
        ViewChooseType.addSubview(arrowLabel)
        arrowLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(button3).offset(width/2 + 19)
            make.centerY.equalTo(ViewChooseType).offset(-2)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
        let viewLine = UIView()
        ViewChooseType.addSubview(viewLine)
        viewLine.backgroundColor = UIColor.lightGrayColor()
        viewLine.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(0.5)
            make.bottom.equalTo(ViewChooseType).offset(-0.5)
            make.width.equalTo(ViewChooseType)
            make.centerX.equalTo(ViewChooseType)
        }
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
        let clearView = UIView()
        clearView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = clearView
        
        //添加上拉加载控件
        tableView.footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.getMoreData(self.index, count: self.count, success: { (data) -> Void in
                for var x in data{
                    self.data.append(x)
                }
                self.tableView.reloadData()
                self.tableView.footer.endRefreshing()
                }, failure: { () -> Void in
                    SVProgressHUD.showInfoWithStatus("没有更多数据了")
                    self.tableView.footer.endRefreshing()
            })
        })
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
            let vc = UIStoryboard(name: "Home", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("itemDetail") as! OtherViewController
            vc.address = address
            vc.itemNo = itemno
            //self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
