//
//  MyCenterController.swift
//  Demo
//
//  Created by mac on 16/1/23.
//  Copyright © 2016年 Fjnu. All rights reserved.
//
//  我的订单

import UIKit
class OrderViewController: UIViewController{
    
    @IBOutlet var seg: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    private var orderArray: OrderModel!
    private var orderStatu: String = "-1"
    private var pageIndex: Int = 1
    var ispush = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的订单"
        view.backgroundColor = theme.SDBackgroundColor
        
        pullRefreshData()
        setTableView()
    }
    
    func setTableView(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // 设置TableViewHeader
        self.tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.pullRefreshData()
            self.tableView.header.endRefreshing()
        })
        
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.dropDownLoading()
            self.tableView.footer.endRefreshing()
        })
    }
    
    func pullRefreshData(){
        //重新加载所有数据
       loadDataModel("\(self.seg.selectedSegmentIndex - 1)",requestType: true)
        if(orderArray == nil) {
            SVProgressHUD.showErrorWithStatus("数据加载失败")
        }

//        print("刷新后数据数量\(self.orderArray.listorder.count)")
    }
    
    func dropDownLoading(){
        //原有数据上增加
        loadDataModel("\(self.seg.selectedSegmentIndex - 1)", requestType: false)
//        print("加载后数据数量\(self.orderArray.listorder.count)")
    }
    
}
// MARK: - view 上的处理
extension OrderViewController {

    @IBAction func changeSegment(sender: AnyObject) {
        orderStatu = "\(seg.selectedSegmentIndex - 1)"
        loadDataModel(orderStatu,requestType: true)
    }
    //从服务器上载入数据并封装成对象
    func loadDataModel(orderStatu: String, requestType: Bool){
        let custNo: String = UserAccountTool.userAccount()!
        var parameters: [String : AnyObject]
        if(requestType == true) {
            
            parameters = ["No": custNo,"pageIndex":1,"pageCount":2,"orderStatu":orderStatu]
            
        }
        else {
            pageIndex++
            parameters = ["No": custNo,"pageIndex":pageIndex,"pageCount":2,"orderStatu":orderStatu]
        }
        HTTPManager.POST(ContentType.UserOrder, params: parameters ).responseJSON({ (json) -> Void in
            print(json)
            if let orderpage = json as? NSDictionary {
                if let page = orderpage["orderPage"] as? NSDictionary {
                    let exp = OrderModel()
                    exp.listorder = []
                    exp.dataCount = page["dataCount"] as! Int
                    if let list = page["list"] as? NSArray {
                        for var i=0 ; i<list.count ; i++ {
                            let listorder = orderInfo()
                            if let oinfo = list[i]["orderInfo"] as? NSDictionary {
                                listorder.orderNo = oinfo["orderNo"] as? String
                                listorder.totalAmt = oinfo["totalAmt"] as? Double
                                listorder.freeAmt = oinfo["freeAmt"] as? Double
                                listorder.payDate = oinfo["createDateString"] as! String
                                listorder.itemNum  = oinfo["itemNum"] as! Int
                                if let receiveAddress = list[i]["receiveAddress"] as? NSDictionary {
                                    listorder.address = receiveAddress["address"] as?
                                    String
                                    listorder.tel = receiveAddress["tel"] as? String
                                }
                            }
                            if let item = list[i]["itemList"] as? NSArray {
                                listorder.itemList = []
                                for var j=0 ; j<item.count ; j++ {
                                    let itemList = goodList()
                                    itemList.nowUnit = item[j]["nowUnit"] as? String
                                    itemList.nowPack = item[j]["nowPack"] as!
                                    Int
                                    itemList.subQty = item[j]["subQty"] as! Int
                                    itemList.subAmt = item[j]["subAmt"] as? Double
                                    itemList.orgPrice = item[j]["orgPrice"] as? Double
                                    itemList.realPrice = item[j]["realPrice"] as?
                                    Double
                                    if let good = item[j]["item"] as? NSDictionary {
                                        itemList.itemName = good["itemName"] as? String
                                        itemList.url = good["url"] as? String
                                    }
                                    listorder.itemList?.append(itemList)
                                }
                            }
                            if(requestType == false) {
                                self.orderArray.listorder.append(listorder)
                            }
                            exp.listorder?.append(listorder)
                        }
                    }
                    if(requestType == true) {
                        self.orderArray = exp
                    }
                }
            }
            self.tableView.reloadData()
            }) { (error) -> Void in
                print("发生了错误\(error)")
        }
    }
}
// MARK: - tableview 上的数据和协议
extension OrderViewController: UITableViewDataSource,UITableViewDelegate {
    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.orderArray == nil {
            return 0
        }
        else {
            
            return self.orderArray.listorder.count
        }
    }
    
    internal func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    internal func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if seg.selectedSegmentIndex == 1 {
            return 4
        }
        return 3
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = ""
        if(indexPath.row == 0){
            cellId = "title"
        }
        else if(indexPath.row == 1){
            cellId = "store"
        }
        else if(indexPath.row == 2){
            cellId = "foot"
        }
        else if (self.seg.selectedSegmentIndex == 1) {
            cellId = "buttonCell"
        }
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        if(cellId == "title"){
            let dingDanHao = cell?.viewWithTag(10001) as! UILabel
            let dingDanZhuangtai = cell?.viewWithTag(10002) as! UILabel
            dingDanHao.text = self.orderArray.listorder[indexPath.section].orderNo
            dingDanZhuangtai.text = "正在配送"
            // cell取消选中效果
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        if(cellId == "store"){
            let goodsimage = cell?.viewWithTag(20001) as! UIImageView
            let mingcheng = cell?.viewWithTag(20002) as! UILabel
            let danjia = cell?.viewWithTag(20003) as! UILabel
            let shuliang = cell?.viewWithTag(20004) as! UILabel
            let zongjia = cell?.viewWithTag(20005) as! UILabel
            goodsimage.sd_setImageWithURL(NSURL(string: self.orderArray.listorder[indexPath.section].itemList[0].url!), placeholderImage: UIImage(named: "quesheng"))
            let attributeText1 = NSMutableAttributedString(string: "数量: \(self.orderArray.listorder[indexPath.section].itemList[0].subQty!)")
            attributeText1.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText1.length - 3))
            shuliang.attributedText = attributeText1
            mingcheng.text = self.orderArray.listorder[indexPath.section].itemList[0].itemName
            danjia.text = "￥\(self.orderArray.listorder[indexPath.section].itemList[0].subQty!)"
            let attributeText2 = NSMutableAttributedString(string: "合计: ￥\(self.orderArray.listorder[indexPath.section].itemList[0].subAmt!)")
            attributeText2.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText2.length - 3))
            zongjia.attributedText = attributeText2
            // cell取消选中效果
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        if(cellId == "foot"){
            let shuliang = cell?.viewWithTag(30001) as! UILabel
            let zongjia = cell?.viewWithTag(30003) as! UILabel
            let sl = self.orderArray.listorder[indexPath.section].itemNum
            shuliang.text = "共\(sl!)件商品"
            let attributeText = NSMutableAttributedString(string: "总计: ￥\(self.orderArray.listorder[indexPath.section].totalAmt!)")
            attributeText.setAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(3, attributeText.length - 3))
            zongjia.attributedText = attributeText
            // cell取消选中效果
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        if(cellId == "buttonCell"){
            let quxiao = cell?.viewWithTag(40001) as! UIButton
            let fukuan = cell?.viewWithTag(40002) as! UIButton
            quxiao.layer.borderWidth = 0.5
            fukuan.layer.borderWidth = 0.5
            quxiao.addTarget(self, action: "deleteOrderAction", forControlEvents: UIControlEvents.TouchDown)
            fukuan.addTarget(self, action: "spendOrderAction", forControlEvents: UIControlEvents.TouchDown)
        }
        return cell!

    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 40.0
        }
        else if(indexPath.row == 1){
            return 90.0
        }
        else {
            return 40.0
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let story = UIStoryboard(name: "MyOrderStoryBoard", bundle: nil)
        let vc = story.instantiateViewControllerWithIdentifier("OrderInfoController") as? OrderInfoController
        vc?.orderInformation = self.orderArray.listorder[indexPath.section]
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}