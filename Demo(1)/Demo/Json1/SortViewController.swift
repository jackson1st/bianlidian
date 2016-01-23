//
//  SortViewController.swift
//  webDemo
//
//  Created by Jason on 15/11/8.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit
import WebKit
class SortViewController: UIViewController{

    var ViewSearch: UIView!
    var tableViewLeft: UITableView!
    var collectionViewRight: UICollectionView!
    lazy var bigClass = [String]()
    var smallCalsses = [smallClass]()
    var address: String!
    var userDefault = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor.colorWith(242, green: 50, blue: 65, alpha: 1)
        address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
        initAll()
    }
    
    lazy var searchVC:SearcherViewController = {
        let story = UIStoryboard(name: "Home", bundle: nil)
        let vc = story.instantiateViewControllerWithIdentifier("searchView") as! SearcherViewController
        return vc
    }()
    /**
     职责链！！！
     响应搜索控制器当中的点击事件
     */
    func endingEditing(){
        searchVC.endingEditing()
    }
    
    //响应搜索按钮的方法
    func pushSearchViewController(){
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
//MARK:-一些初始化
extension SortViewController{
    
    func initAll(){
        initSearch()
        initTableview()
        initCollectionView()
        initData()
        let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        self.hidesBottomBarWhenPushed = true
    }
    
    func initSearch(){
        let button = UIButton()
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle("输入便利店或商品名称", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        button.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
        button.imageEdgeInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.layer.cornerRadius = 4
        self.navigationController?.navigationBar.addSubview(button)
        button.snp_makeConstraints { (make) -> Void in
            make.center.equalTo((self.navigationController?.navigationBar)!)
            make.width.equalTo(330)
            make.height.equalTo(26)
        }
        button.addTarget(self, action: "pushSearchViewController", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func initData(){
        
        HTTPManager.POST(ContentType.ItemBigClass, params: nil).responseJSON({ (json) -> Void in
            let bigclass = json["bigclass"] as? [NSDictionary]
            var tg = true
            for var x in bigclass!{
                self.bigClass.append(x["name"] as! String)
                if tg {
                    let properties = x["property"] as? [NSDictionary]
                    for var y in properties!{
                        self.smallCalsses.append(smallClass(name: y["propertyName"] as? String, url: y["url"] as? String,id: y["propertyId"] as? String))
                    }
                    tg = false
                }
            }
            self.tableViewLeft.reloadData()
            self.collectionViewRight.reloadData()
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
    }
    
    func initTableview(){
        tableViewLeft = UITableView()
        tableViewLeft.delegate = self
        tableViewLeft.dataSource = self
        tableViewLeft.rowHeight = 40
        self.view.addSubview(tableViewLeft)
        tableViewLeft.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(80)
            make.left.equalTo(view)
            make.top.equalTo(view).offset(64)
            make.bottom.equalTo(view.snp_bottom)
        }
    }
    
    func initCollectionView(){
        let flowLayout =  UICollectionViewFlowLayout()
        
        //        flowLayout.itemSize = self.frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .Vertical
        collectionViewRight = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionViewRight.delegate = self
        collectionViewRight.dataSource = self
        collectionViewRight.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionViewRight)
        collectionViewRight.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(tableViewLeft.snp_right)
            make.top.equalTo(view).offset(64)
            make.right.equalTo(view)
            make.bottom.equalTo(view.snp_bottom)
        }
        var nib = UINib(nibName: "smallClassCell", bundle: nil)
        collectionViewRight.registerNib(nib, forCellWithReuseIdentifier: "cell")
    }
    
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension SortViewController: UITableViewDelegate,UITableViewDataSource{
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bigClass.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableViewLeft.dequeueReusableCellWithIdentifier("cellLeft")
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell?.selectionStyle = .None
        }
        cell?.textLabel?.text = bigClass[indexPath.row]
        cell?.textLabel?.textAlignment = .Center
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        smallCalsses.removeAll()
        
        HTTPManager.POST(ContentType.ItemSmallClass, params: ["name": bigClass[indexPath.row]]).responseJSON({ (json) -> Void in
            let properties = json["property"] as! [NSDictionary]
            for var y in properties{
                self.smallCalsses.append(smallClass(name: y["propertyName"] as? String, url: y["url"] as? String,id: y["propertyId"] as? String))
            }
            self.collectionViewRight.reloadData()
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
    
    }
    
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension SortViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(smallCalsses.count)
        return smallCalsses.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionViewRight.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! smallClassCell
        cell.imgView.setImageWithURL(NSURL(string: smallCalsses[indexPath.row].url!))
        cell.textLabel.text = smallCalsses[indexPath.row].name
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = SearcherResultViewController()
        vc.address = address
        vc.keyForSearchResult = smallCalsses[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(80, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    
}
