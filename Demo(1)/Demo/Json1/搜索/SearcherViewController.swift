//
//  SearcherViewController.swift
//  Demo
//
//  Created by jason on 15/12/10.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit
import pop

protocol SearcherViewControllerDelegate: NSObjectProtocol{
    func pushResultViewController(resultV: SearcherResultViewController)
}

class SearcherViewController: UIViewController {

    var navVC: UINavigationController!
    var address: String!
    var userDefault = NSUserDefaults()
    
    var view1:UIView!//用来存放热门搜索
    lazy var MainView: UIView = {
        let view2 = UIView(frame: self.view.frame)
        view2.backgroundColor = UIColor.colorWith(243, green: 241, blue: 244, alpha: 1)
        self.view.addSubview(view2)
        return view2
    }()
    var hotText:[String]!
    lazy var Labelhot: UILabel = {
        let label = UILabel(frame: CGRectMake(10, 0, 200, 45))
        label.textAlignment = NSTextAlignment.Left
        label.textColor = UIColor.darkTextColor()
        label.font = UIFont.systemFontOfSize(15)
        label.text = "热门搜索"
        return label
    }()
    
    lazy var history: [String] = {
        let userDefault = NSUserDefaults()
        var strs = userDefault.objectForKey("history") as? [String]
        if(strs == nil){
            strs = [String]()
        }
        return strs!
    }()
    var resultController: SearcherResultViewController?
    var searchKeyVC : SearchkeyViewController!
    var SearchResultView: UIView?
    var searchvc: UISearchController!
    var historytableView: UITableView?
    var ButtonCancel: UIButton!
    var flag = false
    
    
    weak var delegate: SearcherViewControllerDelegate?
    lazy var backBtn: UIButton = {
        //设置返回按钮属性
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.titleLabel?.font = UIFont.systemFontOfSize(17)
        backBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        backBtn.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        backBtn.setImage(UIImage(named: "back_0"), forState: .Normal)
        backBtn.setImage(UIImage(named: "back_2"), forState: .Highlighted)
        backBtn.addTarget(self, action: "didTappedBackButton", forControlEvents: .TouchUpInside)
//        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, -17)
//        backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        let btnW: CGFloat = 10
        backBtn.frame = CGRectMake(0, 0, btnW, 40)
        return backBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.colorWith(243, green: 241, blue: 244, alpha: 1)
        navVC = self.navigationController
        initAll()
        //实现需要定位，有bug
        address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewDidAppear(animated)
    }
    
    deinit{
        print("被销毁了")
    }
    
    //有强引用，导致控制器无法正常销毁，后期需要解决，目前先写在这个方法过渡
    override func viewDidDisappear(animated: Bool) {
        userDefault.setObject(history, forKey: "history")
        super.viewDidDisappear(animated)
    }
    
    func didTappedBackButton(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //清除搜索历史记录
    func ClearSearchHistory(){
        let alert = UIAlertController(title: "清空搜索历史记录", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            self.history = []
            self.historytableView!.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


}
//MARK:-一些操作实现
extension SearcherViewController{
    
    
    func ButtonHotClicked(sender: AnyObject){
        let btn = sender as! UIButton
        TheKeyGoToResultViewController((btn.titleLabel?.text)!)
    }
    
}


//MARK:一些初始化
extension SearcherViewController{
    
    func initAll(){
        initSearch()
        initViewHotSea()
    }
    
    func initSearch(){
        
        searchKeyVC = SearchkeyViewController()
        searchKeyVC.delegate = self
        searchvc = UISearchController(searchResultsController: searchKeyVC)
        searchvc.searchBar.delegate = self
        searchvc.searchResultsUpdater = searchKeyVC
        searchvc.hidesNavigationBarDuringPresentation = false
        searchvc.dimsBackgroundDuringPresentation = false
        searchvc.searchBar.barStyle = .Default
        searchvc.searchBar.placeholder = "输入便利店或商品名称"
        searchvc.searchBar.clearsContextBeforeDrawing = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView:backBtn)
        navigationItem.titleView =  searchvc.searchBar
        definesPresentationContext = true
    }
    
    func initHistoryTableView(){
        
        historytableView = UITableView(frame: CGRect(x: 0, y: view1.y + view1.height + 7, width: self.view.frame.width, height: self.view.height - 64 - view1.height - 15), style: .Plain)
        historytableView?.keyboardDismissMode = .OnDrag
        MainView.addSubview(historytableView!)
        let footButton = UIButton()
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 40))
        historytableView?.addTopLine(0.5, offsetLeft: 0, offsetRight: 0)
        footButton.setTitle("清空搜索历史", forState: .Normal)
        footButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        footButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        footButton.setTitleColor(UIColor.colorWith(242, green: 48, blue: 58, alpha: 1), forState: .Normal)
        footButton.titleLabel?.textAlignment = .Center
        footButton.addTarget(self, action: "ClearSearchHistory", forControlEvents: .TouchUpInside)
        footButton.layer.cornerRadius = 4
        footButton.layer.borderColor = UIColor.colorWith(242, green: 48, blue: 58, alpha: 1).CGColor
        footButton.layer.borderWidth = 0.5
        footView.addSubview(footButton)
        footButton.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(footView)
            make.height.equalTo(25)
            make.width.equalTo(footView).offset(-250)
        }
        footView.addTopLine(0.5, offsetLeft: 15, offsetRight: 0)
        historytableView!.tableFooterView = footView
        historytableView!.delegate = self
        historytableView!.dataSource = self
        historytableView!.reloadData()
        
    }
    
    func initViewHotSea(){
        view1 = UIView(frame: self.view.frame)
        view1.backgroundColor = UIColor.whiteColor()
        view1.translatesAutoresizingMaskIntoConstraints = false
        MainView.addSubview(view1)
        view1.addSubview(Labelhot)
        
        
        let btnH:CGFloat  = 32
        var btnY:CGFloat  = CGRectGetMaxY(Labelhot.frame)
        var btnW:CGFloat  = 0
        let margin:CGFloat  = 5
        let textMargin:CGFloat = 25
        var lastBtn: UIButton?
        HTTPManager.POST(ContentType.SearchHotKey, params: nil).responseJSON({ (json) -> Void in
            self.hotText = json["keywords"] as! [String]
            print(self.hotText)
            for var x in self.hotText! {
                let btn = UIButton()
                btn.titleLabel?.font = UIFont.systemFontOfSize(15)
                btn.setTitle(x, forState: .Normal)
                btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
                btn.titleLabel!.sizeToFit()
                btn.setBackgroundImage(UIImage(named: "populartags"), forState: .Normal)
                btn.addTarget(self, action: "ButtonHotClicked:", forControlEvents: .TouchUpInside)
                btnW = (btn.titleLabel?.width)! + textMargin
                if lastBtn == nil {
                    lastBtn = btn
                    btn.frame = CGRectMake(margin, btnY, btnW, btnH)
                }else{
                    let freeW = AppWidth - CGRectGetMaxX(lastBtn!.frame)
                    if freeW > btnW + 2 * margin {
                        btn.frame = CGRectMake(CGRectGetMaxX(lastBtn!.frame) + margin, btnY, btnW, btnH)
                    } else {
                        btnY = CGRectGetMaxY(lastBtn!.frame) + margin
                        btn.frame = CGRectMake(margin, btnY, btnW, btnH)
                    }
                    lastBtn = btn
                }
                self.view1.addSubview(btn)
                self.view1.frame.size.height = btn.frame.origin.y + btn.frame.size.height + 10
            }
            self.view1.frame.origin.y += 70
            self.initHistoryTableView()
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
    }
}
// MARK: - UISearchControllerDelegate
extension SearcherViewController: SearchkeyViewControllerDelegate,UISearchBarDelegate{
    
    func TheKeyGoToResultViewController(key: String) {
        if(history.contains(key) == true){
            history.removeAtIndex(history.indexOf(key)!)
        }
        history.insert(key, atIndex: 0)
        searchvc.searchBar.text = key
        let searchResultViewController = SearcherResultViewController()
        searchResultViewController.address = address
        searchResultViewController.keyForSearchResult = key
        searchResultViewController.hidesBottomBarWhenPushed = true
        self.delegate?.pushResultViewController(searchResultViewController)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        TheKeyGoToResultViewController(searchBar.text!)
    }
}



extension SearcherViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if(cell == nil){
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = self.history[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.history.count == 0){
            historytableView?.tableFooterView?.hidden = true
        }else{
            historytableView?.tableFooterView?.hidden = false
        }
        return self.history.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let key = self.history[indexPath.row]
        TheKeyGoToResultViewController(key)
    }
    
}


