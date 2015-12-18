//
//  SortViewController.swift
//  webDemo
//
//  Created by Jason on 15/11/8.
//  Copyright © 2015年 jason. All rights reserved.
//

import UIKit
import WebKit
class SortViewController: UIViewController,WKNavigationDelegate{

    var TextFieldSearchBar: UITextField!
    var ViewSearch: UIView!
    var tableViewLeft: UITableView!
    var collectionViewRight: UICollectionView!
    lazy var bigClass = [String]()
    var smallCalsses = [smallClass]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK:-一些初始化
extension SortViewController{
    
    func initAll(){
        initViewSearch()
        initTableview()
        initCollectionView()
        initData()
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
                       print(y)
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
        ViewSearch.addSubview(TextFieldSearchBar)
        TextFieldSearchBar.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(ViewSearch)
            make.left.equalTo(ViewSearch).offset(20)
            make.height.equalTo(26)
        }
        // TextFieldSearchBar.delegate = self
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
        collectionViewRight = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewLayout())
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
        var nib = UINib(nibName: "smallClassCell", bundle: NSBundle.mainBundle())
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
        }
        cell?.textLabel?.text = bigClass[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension SortViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallCalsses.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionViewRight.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! smallClassCell
        cell.imgView.setImageWithURL(NSURL(string: smallCalsses[indexPath.row].url!))
        cell.textLabel.text = smallCalsses[indexPath.row].name
        return cell
    }
}
