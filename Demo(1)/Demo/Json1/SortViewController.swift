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
    var letftTableview: UITableView!
    var rightTableView: UITableView!
    
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
    
    }
    
}

