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

    var TextFieldSearchBar: UITextField!
    var ViewSearch: UIView!
    var tableViewLeft: UITableView!
    var collectionViewRight: UICollectionView!
    lazy var bigClass = [String]()
    var smallCalsses = [smallClass]()
    
    var address: String!
    var userDefault = NSUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
        initAll()
    }
    
    lazy var searchVC:SearcherViewController = {
        var story = UIStoryboard(name: "Home", bundle: nil)
        let vc = story.instantiateViewControllerWithIdentifier("searchView") as! SearcherViewController
        return vc
    }()

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        endingEditing()
    }
    
    func endingEditing(){
        TextFieldSearchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
//MARK:-一些初始化
extension SortViewController{
    
    func initAll(){
        initViewSearch()
        initTableview()
        initCollectionView()
        initData()
        let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        self.hidesBottomBarWhenPushed = true
        
        var gesture = UITapGestureRecognizer(target: self, action: "endingEditing")
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
    }
    
    func initData(){
        Pitaya.build(HTTPMethod: .POST, url: "http://192.168.199.242:8080/BSMD222/item/classlist.do").responseJSON({ (json, response) -> Void in
            let bigclass = json.data["bigclass"] as? [NSDictionary]
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
        })
    }
    
    func initViewSearch(){
        
        ViewSearch = UIView(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: 64))
        ViewSearch.backgroundColor = UIColor.colorWith(245, green: 77, blue: 86, alpha: 1)
        view.addSubview(ViewSearch)
        
        TextFieldSearchBar = UITextField()
        TextFieldSearchBar.backgroundColor = UIColor.whiteColor()
        TextFieldSearchBar.placeholder = "输入便利店或商品名称"
        TextFieldSearchBar.layer.cornerRadius = 4
        TextFieldSearchBar.textAlignment = .Center
        if(navigationController == nil){
            print("yes")
        }
        self.navigationController?.navigationBar.addSubview(TextFieldSearchBar)
        TextFieldSearchBar.snp_makeConstraints { (make) -> Void in
            make.right.equalTo((navigationController?.navigationBar.snp_right)!).offset(-10)
            make.left.equalTo((navigationController?.navigationBar.snp_left)!).offset(30)
            make.centerY.equalTo((navigationController?.navigationBar.snp_centerY)!)
            make.height.equalTo(26)
        }
        TextFieldSearchBar.delegate = self
    }
    
    func initTableview(){
        tableViewLeft = UITableView()
        tableViewLeft.delegate = self
        tableViewLeft.dataSource = self
        self.view.addSubview(tableViewLeft)
        tableViewLeft.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.left.equalTo(view)
            make.top.equalTo(ViewSearch.snp_bottom)
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
            make.top.equalTo(ViewSearch.snp_bottom)
            make.right.equalTo(ViewSearch.snp_right)
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
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        smallCalsses.removeAll()
        let json: JSONND = ["name": bigClass[indexPath.row]]
        Pitaya.build(HTTPMethod: .POST, url: "http://192.168.199.242:8080/BSMD222/item/getclass.do").setHTTPBodyRaw(json.RAWValue, isJSON: true).responseJSON { (json, response) -> Void in
            let properties = json.data["property"] as! [NSDictionary]
            for var y in properties{
                self.smallCalsses.append(smallClass(name: y["propertyName"] as? String, url: y["url"] as? String,id: y["propertyId"] as? String))
            }
            self.collectionViewRight.reloadData()
        }
    }
    
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension SortViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(smallCalsses.count)
        return smallCalsses.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionViewRight.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! smallClassCell
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
}

// MARK: - UITextFieldDelegate
extension SortViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        self.navigationController?.pushViewController(searchVC, animated: true)
        TextFieldSearchBar.resignFirstResponder()
    }
}
