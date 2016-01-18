//
//  JFShoppingCartViewController.swift
//  shoppingCart
//
//

import UIKit

public let SD_RefreshImage_Height: CGFloat = 40
public let SD_RefreshImage_Width: CGFloat = 35

class JFShoppingCartViewController: UIViewController{
    
    var SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
    var SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
    // MARK: - 属性
    /// 已经添加进购物车的商品模型数组，初始化
    private var canSelectShop: [String] = []
    private let loadAnimatIV: LoadAnimatImageView! = LoadAnimatImageView.sharedManager
    /// 传入金额
    var payPrice: CFloat = 0.00
    /// 总金额，默认0.00
    var price: CFloat = 0.00
    var selectShop: String?
    var backButtonShow: Bool = false
    /// 商品列表cell的重用标识符
    private let shoppingCarCellIdentifier = "shoppingCarCell"
    
    // MARK: - view生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dloadmodel()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTable", name: "finishLoadDataFromNetwork", object: nil)
        prepareUI()
        if(Model.defaultModel.shopCart.count > 0){
            self.canSelectShop.append(Model.defaultModel.shopCart[0].shopNameList[0].shopName!)
        }
        self.showMySelect()
        self.tableView.reloadData()
        
    }
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func reloadTable(){
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        //         布局UI
        layoutUI()
        
        // 重新计算价格
        reCalculateGoodCount()
    }
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 标题
        navigationItem.title = "购物车列表"
        self.tabBarController!.tabBar.hidden = false;
        // 导航栏左边返回
        if(backButtonShow){
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "didTappedBackButton")
            self.tabBarController!.tabBar.hidden = true
        }
        // view背景颜色
        view.backgroundColor = UIColor.whiteColor()
        
        // cell行高
        
        tableView.rowHeight = 80
        
        // 注册cell
        tableView.registerClass(JFShoppingCartCell.self, forCellReuseIdentifier: shoppingCarCellIdentifier)
        
        // 设置TableViewHeader
        self.tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.tableView.reloadData()
            self.reCalculateTotalPrice()
            self.tableView.header.endRefreshing()
        })
        
        // 添加子控件
        view.addSubview(tableView)
        view.addSubview(bottomView)
        bottomView.addSubview(selectButton)
        bottomView.addSubview(totalPriceLabel)
        bottomView.addSubview(buyButton)
        // 判断是否需要全选
        
        for model in Model.defaultModel.shopCart {
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
            make.top.equalTo(0)
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
            make.centerX.equalTo(bottomView.snp_centerX)
            make.centerY.equalTo(bottomView.snp_centerY)
        }
        
        
    }
    
    // MARK: - 懒加载
    
    
    
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
    
    /// 设置TableViewTitle
//    func setTableViewHeader(refreshingTarget: AnyObject, refreshingAction: Selector, imageFrame: CGRect, tableView: UITableView) {
//        let header = SDRefreshHeader(refreshingTarget: refreshingTarget, refreshingAction: refreshingAction)
//        header.gifView!.frame = imageFrame
//        tableView.header = header
//    }
    
}
// MARK: - UITableViewDataSource, UITableViewDelegate数据、代理
extension JFShoppingCartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.defaultModel.shopCart.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 从缓存池创建cell,不成功就根据重用标识符和注册的cell新创建一个
        let cell = tableView.dequeueReusableCellWithIdentifier(shoppingCarCellIdentifier, forIndexPath: indexPath) as! JFShoppingCartCell
        
        // cell取消选中效果
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        // 指定代理对象
        cell.delegate = self
        
        // 传递模型
        cell.goodModel = Model.defaultModel.shopCart[indexPath.row]
        
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
        Model.defaultModel.shopCart.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath],withRowAnimation: UITableViewRowAnimation.Fade)
        reCalculateGoodCount()
    }
}

// MARK: - view上的一些事件处理
extension JFShoppingCartViewController {
    
    //开始刷新
    func starRefreshView(){
        loadAnimatIV.startLoadAnimatImageViewInView(view, center: view.center)
    }
    //停止刷新
    func stopRefreshView(){
        loadAnimatIV.stopLoadAnimatImageView()
    }
    /**
     返回按钮
     */
    @objc private func didTappedBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
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
            next.sumprice = "\(self.payPrice)"
            next.disprice = "0"
            next.discount = "已优惠 ¥0"
            for var i = 0; i<Model.defaultModel.shopCart.count; i++ {
                if(Model.defaultModel.shopCart[i].selected == true ) {
                    next.payModel.append(Model.defaultModel.shopCart[i])
                }
            }
            self.presentViewController(UINavigationController(rootViewController: next), animated: false, completion: nil)
            //            self.navigationController?.pushViewController(next, animated: true)
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
        for model in Model.defaultModel.shopCart{
            
            // 只计算选中的商品
            if model.selected == true && model.canChange == true {
                print("\(price) \(model.itemSalePrice)")
                var str = model.itemSalePrice! as NSString
                let isPerfix = str.hasPrefix("￥")
                if !isPerfix {
                    str = str.substringFromIndex(2)
                }
                price += Float(model.num) * (str).floatValue
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
        for model in Model.defaultModel.shopCart {
            if model.canChange == true  {
                model.selected = selectButton.selected
                
            }
        }
        
        // 重新计算总价
        reCalculateGoodCount()
        
        // 刷新表格
        tableView.reloadData()
    }
    
    // 创造可操作数据
    func showMySelect(){
        // self.Model.defaultModel.shopCart = self.staticGoodModels
        canSelectShop.removeAll()
        //获得所有店名
        for var i = 0; i<Model.defaultModel.shopCart.count; i++ {
            for var j = 0; j<Model.defaultModel.shopCart[i].shopNameList.count; j++ {
                if !canSelectShop.contains(Model.defaultModel.shopCart[i].shopNameList[j].shopName!) {
                    canSelectShop.append(Model.defaultModel.shopCart[i].shopNameList[j].shopName!)
                }
            }
        }
        if(self.canSelectShop.isEmpty == false) {
//            self.selectBrunch.text = self.canSelectShop[0]
//            canChange(self.selectBrunch.text!)
        }
        reCalculateGoodCount()
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
        for var i=0 ; i<Model.defaultModel.shopCart.count ; i++ {
            for var j=0 ; j<Model.defaultModel.shopCart[i].shopNameList!.count ; j++ {
                if (Model.defaultModel.shopCart[i].shopNameList[j].shopName == selectShopName ){
                    print(Model.defaultModel.shopCart[i].shopNameList[j].shopName! + " " + selectShopName)
                    Model.defaultModel.shopCart[i].canChange = true
                    break;
                }
                else {
                    Model.defaultModel.shopCart[i].canChange = false
                }
            }
            if(Model.defaultModel.shopCart[i].canChange == false) {
                Model.defaultModel.shopCart[i].selected = false
            }
        }
    }
    
    // 清空所有数据
    func cleanAllData(){
        canSelectShop.removeAll()
        Model.defaultModel.shopCart.removeAll()
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
        let model = Model.defaultModel.shopCart[indexPath.row]
        
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

extension JFShoppingCartViewController: payDelegate {
    func returnOk(ok: String){
        if(ok == "true"){
            self.tableView.reloadData()
        }
    }
}









