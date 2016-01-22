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
    var hotText:[String]!
    lazy var Labelhot: UILabel = {
        let label = UILabel(frame: CGRectMake(10, 59, 200, 50))
        label.textAlignment = NSTextAlignment.Left
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(16)
        label.text = "热门搜索"
        return label
    }()
    var resultController: SearcherResultViewController?
    var SearchResultView: UIView?
    var ButtonCancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navVC = self.navigationController
        navVC.navigationBar.barTintColor = UIColor.colorWith(242, green: 48, blue: 58, alpha: 1)
        initAll()
        //实现需要定位，有bug
        address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
        let gesture = UITapGestureRecognizer(target: self, action: "endingEditing")
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //装载搜索栏  后期优化，使得不需要每次都装载
        self.tabBarController!.tabBar.hidden = true
        TextFieldSearch = UITextField()
        TextFieldSearch.backgroundColor = UIColor.whiteColor()
        TextFieldSearch.textAlignment = .Center
        TextFieldSearch.placeholder = "输入便利店或商品名称"
        TextFieldSearch.returnKeyType = .Search
        TextFieldSearch.delegate = self
        TextFieldSearch.layer.cornerRadius = 4
        TextFieldSearch.clearButtonMode = .Always
        TextFieldSearch.addTarget(self, action: "contentChange", forControlEvents: UIControlEvents.EditingChanged)
        navVC.navigationBar.addSubview(TextFieldSearch)
        if(ButtonCancel != nil){
            ButtonCancel.removeFromSuperview()
        }
        ButtonCancel = UIButton()
        ButtonCancel.setTitle("取消", forState: .Normal)
        ButtonCancel.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        ButtonCancel.hidden = true
        navVC.navigationBar.addSubview(ButtonCancel)
        ButtonCancel?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(40)
            make.right.equalTo(navVC.navigationBar).offset(-3)
            make.centerY.equalTo(navVC.navigationBar)
            
        })
        ButtonCancel.addTarget(self, action: "endingEditing", forControlEvents: UIControlEvents.TouchUpOutside)
        
        TextFieldSearch.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(navVC.navigationBar.snp_right).offset(-10)
            make.left.equalTo(navVC.navigationBar.snp_left).offset(30)
            make.centerY.equalTo(navVC.navigationBar.snp_centerY)
            make.height.equalTo(26)
        }
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
        TextFieldSearch.text = ""
        TextFieldSearch.resignFirstResponder()
        SearchResultView?.hidden = false
        tableView.hidden = true
    }


}
//MARK:-一些操作实现
extension SearcherViewController{
    
    //发送选择的关键字，从而进行跳转
    func goToSearchResult(str: String){
        if(resultController == nil){
            resultController = SearcherResultViewController()
            SearchResultView = resultController?.view
            self.addChildViewController(resultController!)
            self.view.addSubview(SearchResultView!)
            SearchResultView?.translatesAutoresizingMaskIntoConstraints = false
            SearchResultView?.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(self.view).offset(64)
                make.left.equalTo(self.view)
                make.width.equalTo(self.view)
                make.bottom.equalTo(self.view)
            })
        }
        SearchResultView?.hidden = false
        resultController!.address = address
        resultController!.keyForSearchResult = str
        
    }
    
    //获取搜索关键字
    func getSearchKey(str:String){
        
        HTTPManager.POST(.SearchResultList, params: ["address": address, "name": str]).responseJSON({ (json) -> Void in
            self.data = json["name"] as! [String]
            self.tableView.hidden = false
            self.tableView.reloadData()
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
        
//        Pitaya.build(HTTPMethod:.POST , url: "http://192.168.43.185:8080/BSMD/item/findlist").setHTTPBodyRaw(json.RAWValue, isJSON: true).responseJSON { (json, response) -> Void in
//            
//            self.data = json.data["name"] as! [String]
//
//            self.tableView.hidden = false
//            self.tableView.reloadData()
//        }
        
        
    }
    
    func ButtonHotClicked(sender: AnyObject){
        let btn = sender as! UIButton
        TextFieldSearch.text = btn.titleLabel?.text
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
        let view1 = UIView(frame: self.view.frame)
        self.view.addSubview(view1)
        view1.addSubview(Labelhot)
        let btnH:CGFloat  = 32
        var btnY:CGFloat  = CGRectGetMaxY(Labelhot.frame)
        var btnW:CGFloat  = 0
        let margin:CGFloat  = 10
        let textMargin:CGFloat = 35
        var lastBtn: UIButton?
        HTTPManager.POST(ContentType.SearchHotKey, params: nil).responseJSON({ (json) -> Void in
            self.hotText = json["keywords"] as! [String]
            print(self.hotText)
            for var x in self.hotText! {
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
                view1.addSubview(btn)
            }
            //self.viewDidLoad()
            }) { (error) -> Void in
                 print("发生了错误: " + (error?.localizedDescription)!)
        }
    }
}

//TextField's delegate
extension SearcherViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        SearchResultView?.hidden = true
        //显示“取消”按钮
        //加个pop动画来实现
        self.TextFieldSearch.snp_updateConstraints(closure: { (make) -> Void in
            make.right.equalTo(navVC.navigationBar).offset(-50)
        })
        self.TextFieldSearch.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.ButtonCancel.hidden = false
            })
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.textAlignment = .Center
        //隐藏“取消”按钮
        //加个pop动画来实现
        self.TextFieldSearch.snp_updateConstraints(closure: { (make) -> Void in
            make.right.equalTo(navVC.navigationBar.snp_right).offset(-10)
        })
        self.TextFieldSearch.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.ButtonCancel.hidden = true
            })
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


