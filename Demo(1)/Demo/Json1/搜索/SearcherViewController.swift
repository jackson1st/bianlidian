//
//  SearcherViewController.swift
//  Demo
//
//  Created by jason on 15/12/10.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class SearcherViewController: UIViewController {

    //自定义搜索栏
    var TextFieldSearch: UITextField!
    var tableView: UITableView!
    var navVC: UINavigationController!
    var ViewHot: UIView!
    var data = [String]()
    var address: String!
    var userDefault = NSUserDefaults()
    lazy var hotText:[String] = {
        //模拟数据请求
        var texts:[String] = ["机械键盘","超级泡面","烧鸡","鸡肉配豆浆","抗战茶叶蛋","建国大饼"]
        return texts
    }()
    

    
    lazy var Labelhot: UILabel = {
        let label = UILabel(frame: CGRectMake(10, 59, 200, 50))
        label.textAlignment = NSTextAlignment.Left
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(16)
        label.text = "热门搜索"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navVC = self.navigationController
        initAll()
        //实现需要定位，有bug
        address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
        var gesture = UITapGestureRecognizer(target: self, action: "endingEditing")
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController!.tabBar.hidden = true
        TextFieldSearch = UITextField()
        TextFieldSearch.backgroundColor = UIColor.whiteColor()
        TextFieldSearch.textAlignment = .Center
        TextFieldSearch.placeholder = "输入便利店或商品名称"
        TextFieldSearch.returnKeyType = .Search
        TextFieldSearch.delegate = self
        TextFieldSearch.layer.cornerRadius = 4
        TextFieldSearch.clearButtonMode = .Always
        TextFieldSearch.becomeFirstResponder()
        TextFieldSearch.addTarget(self, action: "contentChange", forControlEvents: UIControlEvents.EditingChanged)
        navVC.navigationBar.addSubview(TextFieldSearch)
        TextFieldSearch.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(navVC.navigationBar.snp_right).offset(-10)
            make.left.equalTo(navVC.navigationBar.snp_left).offset(30)
            make.centerY.equalTo(navVC.navigationBar.snp_centerY)
            make.height.equalTo(26)
        }
        
        TextFieldSearch.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        endingEditing()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TextFieldSearch.snp_removeConstraints()
        TextFieldSearch.removeFromSuperview()
    }
    
    
    
    func endingEditing(){
        TextFieldSearch.resignFirstResponder()
    }


}
//MARK:-一些操作实现
extension SearcherViewController{
    
    //发送选择的关键字，从而进行跳转
    func goToSearchResult(str: String){
        let vc = SearcherResultViewController()
        vc.address = address
        vc.keyForSearchResult = str
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //获取搜索关键字
    func getSearchKey(str:String){
        
        let json: JSONND = ["address": address, "name": str]
        Pitaya.build(HTTPMethod: .POST, url: "http://192.168.199.242:8080/BSMD/item/findlist").setHTTPBodyRaw(json.RAWValue, isJSON: true).responseJSON { (json, response) -> Void in
            
            self.data = json.data["name"] as! [String]

            self.tableView.hidden = false
            self.tableView.reloadData()
        }
    }
    
    func ButtonHotClicked(sender: AnyObject){
        let btn = sender as! UIButton
        goToSearchResult((btn.titleLabel?.text)!)
    }
    
}


//MARK:一些初始化
extension SearcherViewController{
    
    func initAll(){
        initViewHotSea()
        initTableView()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    }

    
    func initTableView(){
        tableView = UITableView(frame: CGRect(x: 0, y: 59, width: self.view.width, height: self.view.height - 59))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.hidden = true
        self.view.addSubview(tableView)
    }
    
    func initViewHotSea(){
        
        self.view.addSubview(Labelhot)
        let btnH:CGFloat  = 32
        var btnY:CGFloat  = CGRectGetMaxY(Labelhot.frame)
        var btnW:CGFloat  = 0
        let margin:CGFloat  = 10
        let textMargin:CGFloat = 35
        var lastBtn: UIButton?
        for var x in hotText {
            let btn = UIButton()
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
            self.view.addSubview(btn)
        }
    }
}

//TextField's delegate
extension SearcherViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        textField.becomeFirstResponder()
        textField.textAlignment = .Left
    }
    
    func contentChange(){
        let str = TextFieldSearch.text
        if(str != ""){
            //发送搜索内容，获取data
            getSearchKey(str!)
        }else{
            tableView.hidden = true
        }
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        
        tableView.hidden = true
        return true
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //发送搜索请求，并更新
        goToSearchResult(textField.text!)
        tableView.hidden = true
        textField.textAlignment = .Center
        textField.resignFirstResponder()
        return true
    }
}

extension SearcherViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if(cell == nil){
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = data[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //点击了之后需要跳转到新的页面
        goToSearchResult(data[indexPath.row])
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
}


