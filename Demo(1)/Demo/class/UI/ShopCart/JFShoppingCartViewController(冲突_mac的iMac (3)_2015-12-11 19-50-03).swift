//
//  JFShoppingCartViewController.swift
//  shoppingCart
//
//  Created by jianfeng on 15/11/17.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit


public let SD_RefreshImage_Height: CGFloat = 40
public let SD_RefreshImage_Width: CGFloat = 35

class JFShoppingCartViewController: UIViewController{
    
    var SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
    var SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
    // MARK: - 属性
    /// 已经添加进购物车的商品模型数组，初始化
    private var staticGoodModels: [JFGoodModel] = []
    private var addGoodArray: [JFGoodModel] = []
    private var canSelectShop: [String] = []
    /// 传入金额
    var payPrice: CFloat = 0.00
    /// 总金额，默认0.00
    var price: CFloat = 0.00
    var selectShop: String?
    /// 商品列表cell的重用标识符
    private let shoppingCarCellIdentifier = "shoppingCarCell"

    // MARK: - view生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        dloadmodel()
        prepareUI()
        tableView.header.beginRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//         布局UI
        layoutUI()
        
        // 重新计算价格
        reCalculateGoodCount()
    }
    private func  prpareUI2() {
        // 标题
        navigationItem.title = "购物车列表"
        self.tabBarController!.tabBar.hidden = true;
        // 导航栏左边返回
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "didTappedBackButton")
        // view背景颜色
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(bottomView)
        bottomView.addSubview(selectButton)
        bottomView.addSubview(totalPriceLabel)
        bottomView.addSubview(buyButton)
        for model in addGoodArray {
            if model.selected != true && model.canChange == true{
                // 只要有一个不等于就不全选
                selectButton.selected = false
                break
            }
        }
    }
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 标题
        navigationItem.title = "购物车列表"
        self.tabBarController!.tabBar.hidden = false;
        // 导航栏左边返回
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "didTappedBackButton")
        // view背景颜色
        view.backgroundColor = UIColor.whiteColor()
        
        // cell行高
        tableView.rowHeight = 80
        
        // 注册cell
        tableView.registerClass(JFShoppingCartCell.self, forCellReuseIdentifier: shoppingCarCellIdentifier)
        
        // 设置TableViewHeader
        setTableViewHeader(self, refreshingAction: "pullLoadDayData", imageFrame: CGRectMake((AppWidth - SD_RefreshImage_Width) * 0.5, 17, SD_RefreshImage_Width, SD_RefreshImage_Height), tableView: tableView)
        
        //配置toolbar
        configureToolbar()
        
        // 添加子控件
        view.addSubview(tableView)
        view.addSubview(bottomView)
        bottomView.addSubview(selectButton)
        bottomView.addSubview(totalPriceLabel)
        bottomView.addSubview(buyButton)
        bottomView.addSubview(selectBrunch)
        // 判断是否需要全选
        
        for model in addGoodArray {
            if model.selected != true && model.canChange == true{
                // 只要有一个不等于就不全选
                selectButton.selected = false
                break
            }
        }

    }


    
    /**
     布局UI
     */
    private func layoutUI() {
        
        // 约束子控件
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(64)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-49)
        }
        
        bottomView.snp_makeConstraints { (make) -> Void in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        selectButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.centerY.equalTo(bottomView.snp_centerY)
        }
        
        totalPriceLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(170)
            make.centerY.equalTo(bottomView.snp_centerY)
        }
        
        selectBrunch.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(100)
            make.centerY.equalTo(bottomView.snp_centerY)
        }
        
    }
    
    // MARK: - 懒加载

    
    /// pickView
    lazy var pickView: UIPickerView = {
        let pickView = UIPickerView()
        pickView.delegate = self
        pickView.dataSource = self
        return pickView
    }()
    
    /// accView
    lazy var accView: UIToolbar = {
        let accView = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 38))
        return accView
    }()
    /// tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        // 指定数据源和代理
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    /// 底部视图
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.whiteColor()
        return bottomView
    }()
    
    /// 底部多选、反选按钮
    lazy var selectButton: UIButton = {
        let selectButton = UIButton(type: UIButtonType.Custom)
        selectButton.setImage(UIImage(named: "check_n"), forState: UIControlState.Normal)
        selectButton.setImage(UIImage(named: "check_y"), forState: UIControlState.Selected)
        selectButton.setTitle("多选\\反选", forState: UIControlState.Normal)
        selectButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        selectButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        selectButton.addTarget(self, action: "didTappedSelectButton:", forControlEvents: UIControlEvents.TouchUpInside)
        selectButton.selected = true
        selectButton.sizeToFit()
        return selectButton
    }()
    
    /// 底部总价Label
    lazy var totalPriceLabel: UILabel = {
        let totalPriceLabel = UILabel()
        let attributeText = NSMutableAttributedString(string: "总价：\(self.price)")
        attributeText.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText.length - 3))
        
        totalPriceLabel.attributedText = attributeText
        totalPriceLabel.sizeToFit()
        return totalPriceLabel
    }()
    
    /// 底部付款按钮
    lazy var buyButton: UIButton = {
        let buyButton = UIButton(type: UIButtonType.Custom)
        buyButton.setTitle("付款", forState: UIControlState.Normal)
        buyButton.setBackgroundImage(UIImage(named: "button_cart_add"), forState: UIControlState.Normal)
        buyButton.frame = CGRect(x: 375 - 100, y: 9, width: 88, height: 30)
        buyButton.layer.cornerRadius = 15
        buyButton.layer.masksToBounds = true
        buyButton.addTarget(self, action: "isPaySelect", forControlEvents: UIControlEvents.TouchUpInside)
        return buyButton
    }()
    
    /// 底部选择店铺按钮
    lazy var selectBrunch: UITextField = {
        let selectBrunch = UITextField()
        selectBrunch.font = UIFont.systemFontOfSize(12)
        return selectBrunch
    }()
    
    /// 设置TableViewTitle
    func setTableViewHeader(refreshingTarget: AnyObject, refreshingAction: Selector, imageFrame: CGRect, tableView: UITableView) {
        let header = SDRefreshHeader(refreshingTarget: refreshingTarget, refreshingAction: refreshingAction)
        header.gifView!.frame = imageFrame
        tableView.header = header
    }
    //配置tool bar Item 函数
    func configureToolbar(){
        let toolbarButtonItem = [addButtonItem,
            flexibleSpaceBarButtonItem,
            cameraButtonItem]
        accView.setItems(toolbarButtonItem, animated: true);
        self.selectBrunch.inputView = pickView
        self.selectBrunch.inputAccessoryView = accView
    }
    
    //tool bar 关闭toolbar按钮 item
    var addButtonItem:UIBarButtonItem{
        
        return UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "backAction:")
    }
    
    //tool bar 确认选择按钮 item
    var cameraButtonItem:UIBarButtonItem{
        
        return UIBarButtonItem(barButtonSystemItem: .Done, target:self, action: "selectAction:")
    }
    
    //tool bar 中间的弹簧
    var flexibleSpaceBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate数据、代理
extension JFShoppingCartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addGoodArray.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 从缓存池创建cell,不成功就根据重用标识符和注册的cell新创建一个
        let cell = tableView.dequeueReusableCellWithIdentifier(shoppingCarCellIdentifier, forIndexPath: indexPath) as! JFShoppingCartCell
        
        // cell取消选中效果
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        // 指定代理对象
        cell.delegate = self
        
        // 传递模型
        cell.goodModel = addGoodArray[indexPath.row]
        
        if cell.goodModel?.canChange == false {
            cell.backgroundColor = UIColor.grayColor()
        }
        else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        reCalculateGoodCount()
    }
    internal func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    internal func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    internal func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        addGoodArray.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath],withRowAnimation: UITableViewRowAnimation.Fade)
        reCalculateGoodCount()
    }
}
//// MARK: - pickView的代理设置和处理
extension JFShoppingCartViewController: UIPickerViewDataSource,UIPickerViewDelegate{
    internal func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    internal func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self.canSelectShop.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return self.canSelectShop[row]
    }
     func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectShop = self.canSelectShop[row]
   }
}

// MARK: - view上的一些事件处理
extension JFShoppingCartViewController {
    
    
    //添加按钮事件
    func backAction(barButtonItem:UIBarButtonItem ){
        
        self.selectBrunch.resignFirstResponder()
    }
    //确认按钮事件
    func selectAction(barButtonItem:UIBarButtonItem ){
    
       self.selectBrunch.text = self.selectShop
       canChange(self.selectBrunch.text!)
       self.selectBrunch.resignFirstResponder()
       self.tableView.reloadData()
       reCalculateGoodCount()
    }
    /**
     返回按钮
     */
    @objc private func didTappedBackButton() {
        self.tabBarController?.selectedIndex = 1
    }
    /**
     付款按钮
    */
    func isPaySelect() {

        showPayAlertView()
    }
    
    func showPayAlertView(){
        let title  = "确认订单?"
        let messge = ""
        let cancelButtonTitle = "返回"
        let otherButtonTitle = "确认"
        
        let ispay = UIAlertController(title: title, message: messge, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            print("取消了订单")
        }
        let addAction = UIAlertAction(title: otherButtonTitle, style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            let payStotyBoard = UIStoryboard(name: "PayStoryboard", bundle: nil)
            let next = payStotyBoard.instantiateViewControllerWithIdentifier("payView") as! PayViewController
            print(self.payPrice)
            next.needPay = "总计 ¥\(self.payPrice)"
            next.discount = "已优惠 ¥0"
            for var i = 0; i<self.addGoodArray.count; i++ {
                if(self.addGoodArray[i].selected == true) {
                    next.payModel.append(self.addGoodArray[i])
                }
            }
            self.presentViewController(UINavigationController(rootViewController: next), animated: true, completion: nil)
        }
        ispay.addAction(cancelAction)
        ispay.addAction(addAction)
        self.presentViewController(ispay, animated: true, completion: nil)
    }
    /**
     重新计算商品数量
     */
    private func reCalculateGoodCount() {
        
        // 遍历模型
        for model in addGoodArray{
            
            // 只计算选中的商品
            if model.selected == true && model.canChange == true {
                price += Float(model.num) * (model.itemSalePrice! as NSString).floatValue
            }
        }
        
        // 赋值价格
        let attributeText = NSMutableAttributedString(string: "总价：\(self.price)")
        attributeText.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText.length - 3))
        totalPriceLabel.attributedText = attributeText
        
        
        //赋值给payPrice
        
        payPrice = price
        
        // 清空price
        price = 0
        
        // 刷新表格
        tableView.reloadData()
    }
    
    /**
     点击了多选按钮后的事件处理
     
     - parameter button: 多选按钮
     */
    @objc private func didTappedSelectButton(button: UIButton) {
        
        selectButton.selected = !selectButton.selected
        for model in addGoodArray {
            if model.canChange == true  {
            model.selected = selectButton.selected
            
            }
        }
        
        // 重新计算总价
        reCalculateGoodCount()
        
        // 刷新表格
        tableView.reloadData()
    }
    
    
    // 载入数据
    func dloadmodel() {
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        let parameters = ["cust":"cust01",
            "areaName":"明阳小区"]
        // manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //这里写需要大量时间的代码
            print("这里写需要大量时间的代码")
            dispatch_async(dispatch_get_main_queue(), {
                manager.POST("http://192.168.199.241:8080/BSMD/car/showCar.do", parameters: parameters, success: { (oper, data) -> Void in
                    if let showCar = data as? NSDictionary{
                        if let jfModellist = showCar["showcar"] as? NSArray {
                            for var i=0 ; i<jfModellist.count ; i++ {
                                if let jfModel = jfModellist[i] as? NSDictionary{
                                    let JFmodel = JFGoodModel()
                                    JFmodel.url = jfModel["url"] as? String
                                    JFmodel.num = jfModel["num"] as! Int
                                    JFmodel.itemName = jfModel["itemName"] as? String
                                    JFmodel.itemSize = jfModel["itemSize"] as? String
                                    let itemSalePrice = jfModel["itemSalePrice"] as? Double
                                    let itemDistPrice = jfModel["itemDistPrice"] as? Double
                                    let totalPrice = jfModel["totalPrice"] as? Double
                                    JFmodel.itemSalePrice = "\(itemSalePrice! - itemDistPrice!)"
                                    JFmodel.itemDistPrice = "\(itemSalePrice!)"
                                    JFmodel.totalPrice = totalPrice
                                    print(JFmodel.itemDistPrice)
                                    if let shopnamelist = jfModel["shopNameList"] as? NSArray{
                                        var arr: [ShopName] = []
                                        for var j=0 ; j<shopnamelist.count ; j++ {
                                            if let shopname = shopnamelist[j] as? NSDictionary{
                                                let spName = ShopName()
                                                spName.shopName = shopname["shopName"] as? String
                                                spName.stockQty = shopname["stockQty"] as? Int
                                                spName.onArea = shopname["onArea"] as? Bool
                                                arr.append(spName)
                                            }
                                            JFmodel.shopNameList = arr
                                        }
                                        self.staticGoodModels.append(JFmodel)
                                    }
                                }
                            }
                        }
                    }
                    //对数据操作加入到 要生成的数据中
                    self.showMySelect()
                    self.tableView.reloadData()
                    }) { (opeation, error) -> Void in
                        print(error)
                }
            })
        })
    }
    
    // 创造可操作数据
    func showMySelect(){
        self.addGoodArray = self.staticGoodModels
        //获得所有店名
        self.canSelectShop.removeAll()
        for var i=0 ; i<self.addGoodArray.count ; i++ {
            for var j=0 ; j<self.addGoodArray[i].shopNameList!.count ; j++ {
                if !self.canSelectShop.contains(self.addGoodArray[i].shopNameList[j].shopName!) {
                    if((self.addGoodArray[i].shopNameList[j].onArea) != false) {
                        self.canSelectShop.append(self.addGoodArray[i].shopNameList[j].shopName!)
                    }
                }
            }
        }
        print(self.canSelectShop)
        if(self.canSelectShop.isEmpty == false) {
            self.selectBrunch.text = self.canSelectShop[0]
            canChange(self.selectBrunch.text!)
        }
        reCalculateGoodCount()
        pickView.reloadAllComponents()
    }

    // 下拉加载刷新数据
    func pullLoadDayData() {
        weak var tmpSelf = self
        
        
        // 模拟延时加载
        let time = dispatch_time(DISPATCH_TIME_NOW,Int64(0.6 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            JFGoodModels.loadEventsData { (data, error) -> () in
                //  if error != nil {
                //  SVProgressHUD.showErrorWithStatus("数据加载失败")
                //  tmpSelf!.tableView.header.endRefreshing()
                //  return
                //  }
                //  tmpSelf!.jfGoodModels = data!
                tmpSelf!.tableView.reloadData()
                tmpSelf!.reCalculateGoodCount()
                tmpSelf!.tableView.header.endRefreshing()
            }
        }
    }
    
    // 根据店铺名判断商品是否可送
    func canChange(selectShopName: String){
        for var i=0 ; i<self.addGoodArray.count ; i++ {
            for var j=0 ; j<self.addGoodArray[i].shopNameList!.count ; j++ {
                if (self.addGoodArray[i].shopNameList[j].shopName == selectShopName ){
                    print(self.addGoodArray[i].shopNameList[j].shopName! + " " + selectShopName)
                    addGoodArray[i].canChange = true
                    break;
                }
                else {
                    addGoodArray[i].canChange = false
                }
            }
            if(addGoodArray[i].canChange == false) {
                addGoodArray[i].selected = false
            }
        }
    }
}

// MARK: - JFShoppingCartCellDelegate代理方法
extension JFShoppingCartViewController: JFShoppingCartCellDelegate {
    
    /**
     当点击了cell中加、减按钮
     
     - parameter cell:       被点击的cell
     - parameter button:     被点击的按钮
     - parameter countLabel: 显示数量的label
     */
    func shoppingCartCell(cell: JFShoppingCartCell, button: UIButton, countLabel: UILabel) {
        
        // 根据cell获取当前模型
        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }
        
        // 获取当前模型，添加到购物车模型数组
        let model = addGoodArray[indexPath.row]
        
        if model.canChange == true {
        
        if button.tag == 10 {
            
            if model.num < 1 {
                print("数量不能低于0")
                return
            }
            
            // 减
            model.num--
            countLabel.text = "\(model.num)"
        } else {
            // 加
            model.num++
            countLabel.text = "\(model.num)"
        }
            
        }
        
        // 重新计算商品数量
        reCalculateGoodCount()
    }
    
    /**
     重新计算总价
     */
    func reCalculateTotalPrice() {
        reCalculateGoodCount()
    }
}











