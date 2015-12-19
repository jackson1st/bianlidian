
import UIKit
import WebKit

class OtherViewController: UIViewController ,WKNavigationDelegate,UINavigationBarDelegate,UIGestureRecognizerDelegate{
    
    
    //MenuView
    @IBOutlet weak var ButtonItem: UIButton!
    @IBOutlet weak var ButtonDetail: UIButton!
    @IBOutlet weak var ButtonEVA: UIButton!
    @IBOutlet weak var ViewFlag: UIView!
    @IBOutlet weak var ConstaintViewFlagLeading: NSLayoutConstraint!
    
    var pictureView: CyclePictureView?
    var detailView: ContentView!
    @IBOutlet weak var toolBar: UIView!
    var scrollView: UIScrollView!
    var firstScrollView: UIScrollView!
    var secondScrollView: UIScrollView!
    
    var contentViewForEVAView: UIView!
    let userDefault = NSUserDefaults()
    var goodSizeView: UITableView!
    var prototypeCell: GoodSizeTableCell!
    var ContentViewForGoodSizeView: UIView!
    var viewDidApper = false
    var screenWidth = Int(UIScreen.mainScreen().bounds.width)
    var photoCur: Int = 0
    var titleForView: String?
    var item: GoodDetail?{
        didSet{
            sumCountForSizeChoose = (item?.itemUnits.count)!
             var arr = [String]()
            arr.append("规格")
            for var i = 0 ; i < item?.itemUnits.count; i++ {
                print(item?.itemUnits[i].sizeName)
                arr.append((item?.itemUnits[i].sizeName)!)
            }
            data.append(arr)
        }
    }
    var data = [[String]]()
    
    //detail
    var needLoadSecondView = true
    
    //EVA
    var needloadThirdView = true
    
    //选择规格
    var dictSizeChoose = NSMutableDictionary()
    var countForSizeChoose = 0
    var sumCountForSizeChoose = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initAll()
    }
    //购买数量
    var viewAddNum: UIView!
    var labelAddNum: UILabel!
    var addNum: Int = 1
    
    //MARK: - 页面出现的事务
        override func viewWillAppear(animated: Bool) {

            self.navigationController?.navigationBarHidden = true
            self.navigationController?.interactivePopGestureRecognizer?.enabled = true
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.tabBarController!.tabBar.hidden = true
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK:-一些控件的方法
extension OtherViewController{
    
    @IBAction func ButtonBackClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func ButtonMenuClicked(sender: AnyObject) {
        let tg = sender.tag - 100
        switch(tg){
        case 1:
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.ConstaintViewFlagLeading.constant = 12
                self.scrollView.contentOffset.x = 0
            })
        case 2:
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.ConstaintViewFlagLeading.constant = 58
                self.scrollView.contentOffset.x = self.view.frame.width
            })
            if( needLoadSecondView){
                initSecondView()
            }
        case 3:
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.ConstaintViewFlagLeading.constant = 105
                self.scrollView.contentOffset.x =  self.view.frame.width * 2
            })
            if(needloadThirdView){
                initThirdView()
            }
        default: break
        }
    }
    @IBAction func ButtonGoToShopCartClicked(sender: AnyObject) {
        
        let vc = JFShoppingCartViewController()
        vc.backButtonShow = true
        self.navigationController?.navigationBarHidden = false
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func ButtonAddItemToShopCartClicked(sender: AnyObject) {
        if(countForSizeChoose != 1){
            SVProgressHUD.showErrorWithStatus("请选择商品规格")
        }else{
            SVProgressHUD.showSuccessWithStatus("成功添加到购物车")
            let JFmodel = JFGoodModel()
            JFmodel.url = item?.imageTop[0]
            JFmodel.num = addNum
            JFmodel.custNo = userDefault.objectForKey(SD_UserDefaults_Account) as? String
            JFmodel.itemName = item?.itemName
            JFmodel.itemNo = item?.itemNo
            JFmodel.itemSize = dictSizeChoose["规格"] as? String
            JFmodel.barcode = item?.barcode
            JFmodel.itemSalePrice = item?.itemSalePrice
            JFmodel.itemDistPrice = item?.itemSalePrice
            JFmodel.totalPrice = 100
            JFmodel.shopNameList = [ShopName]()
            for var x in (item?.itemStocks)!{
                print(x.stockQty)
                print(x.shopName)
                JFmodel.shopNameList.append(ShopName(stockQty: x.stockQty, shopName: x.shopName))
            }
            Model.defaultModel.shopCart.append(JFmodel)
            print(Model.defaultModel.shopCart.count)
        }
    }
    
    //响应规格选择的通知
    func chooseSize(notification: NSNotification){
        let useInfo = notification.userInfo
        let flag = useInfo!["flag"] as! Int
        if(flag == 0){
            //取消这个规格
            countForSizeChoose--
        }else{
            countForSizeChoose++
            dictSizeChoose["规格"] = data[0][flag%100]
        }
    }
    
    //相应增加数量
    func AddNum(sender: AnyObject){
        switch(sender.tag){
        case 101:
            //减
            if(addNum>0){
                addNum--
            }
        default:
            if(addNum<99){
                addNum++
            }
        }
        labelAddNum.text = "\(addNum)"
        labelAddNum.sizeToFit()
    }
    
}

//一些初始化
extension OtherViewController{
    
    func initAll(){
        
        initScrollView()
        initPhotoScan()
        initDetailView()
        initSizeView()
        initNot()
        initViewAddNum()
    }
    
    //注册通知
    func initNot(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "chooseSize:", name: "ChooseSize", object: nil)
    }
    
    //初始化数量修改视图
    func initViewAddNum(){
        viewAddNum = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        viewAddNum.backgroundColor = UIColor.whiteColor()
        var label1 = UILabel()
        label1.textAlignment = .Center
        label1.text = "数量"
        viewAddNum.addSubview(label1)
        label1.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(50)
            make.left.equalTo(viewAddNum)
            make.centerY.equalTo(viewAddNum)
        }
        var btn1 = UIButton()
        btn1.setTitle("-", forState: .Normal)
        btn1.setTitleColor(UIColor.blackColor() , forState: .Normal)
        btn1.layer.cornerRadius = 10
        btn1.layer.borderColor = UIColor.blackColor().CGColor
        btn1.layer.borderWidth = 0.3
        btn1.addTarget(self, action: "AddNum:", forControlEvents: .TouchUpInside)
        btn1.tag = 101
        viewAddNum.addSubview(btn1)
        btn1.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.left.equalTo(label1.snp_right)
            make.centerY.equalTo(viewAddNum)
        }
        
        labelAddNum = UILabel()
        labelAddNum.textColor = UIColor.blackColor()
        labelAddNum.textAlignment = .Center
        labelAddNum.text = "1"
        viewAddNum.addSubview(labelAddNum)
        labelAddNum.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(30)
            make.height.equalTo(20)
            make.left.equalTo(btn1.snp_right)
            make.centerY.equalTo(viewAddNum)
        }
        
        var btn2 = UIButton()
        
        btn2.setTitle("+", forState: .Normal)
        btn2.setTitleColor(UIColor.blackColor() , forState: .Normal)
        btn2.layer.cornerRadius = 10
        btn2.layer.borderColor = UIColor.blackColor().CGColor
        btn2.layer.borderWidth = 0.3
        btn2.addTarget(self, action: "AddNum:", forControlEvents: .TouchUpInside)
        btn2.tag = 102
        viewAddNum.addSubview(btn2)
        btn2.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.left.equalTo(labelAddNum.snp_right)
            make.centerY.equalTo(viewAddNum)
        }
    }
    
    //初始化scrollView
    func initScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 59, width: self.view.width, height: self.view.height-59-49))
        scrollView.contentSize.width = self.view.frame.size.width * 3
        scrollView.contentSize.height = 0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.lightGrayColor()
        scrollView.bounces = false
        scrollView.directionalLockEnabled = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        //初始化第一个scrollView
        firstScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - 49))
        scrollView.addSubview(firstScrollView)
        firstScrollView.contentSize = CGSize(width: self.view.width, height: 10)
        firstScrollView.showsHorizontalScrollIndicator = false
        firstScrollView.showsVerticalScrollIndicator = false
        firstScrollView.bounces = false
        
        //初始化第二个scrollView
        secondScrollView = UIScrollView(frame: CGRect(x: self.view.width, y: 0, width: self.view.width, height: self.view.height - 49-59))
        scrollView.addSubview(secondScrollView)
        secondScrollView.contentSize = CGSize(width: self.view.width, height: 0)
        secondScrollView.showsVerticalScrollIndicator = false
        secondScrollView.showsHorizontalScrollIndicator = false
        secondScrollView.bounces = false
        secondScrollView.backgroundColor = UIColor.whiteColor()
    }
    
    //初始化轮播
    func initPhotoScan(){
        pictureView = CyclePictureView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width), imageURLArray: nil)
        pictureView?.imageURLArray = item?.imageTop
        pictureView?.autoScroll = true
        pictureView?.timeInterval = 3
        firstScrollView.addSubview(pictureView!)
        firstScrollView.contentSize.height += (pictureView?.height)!
    }
    
    
    //初始化商品描述视图
    func initDetailView(){
        let nib = NSBundle.mainBundle().loadNibNamed("ItemContentView", owner: self, options: nil)
        detailView = nib[0] as! ContentView
        detailView.setLabel(item?.itemName, price: item?.itemSalePrice, sco: "获得积分:" + "\((item?.eshopIntegral)!)", salesNum: item?.itemBynum1)
        firstScrollView.addSubview(detailView)
        detailView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo((pictureView?.snp_left)!).offset(0)
            make.top.equalTo((pictureView?.snp_bottom)!).offset(10)
            make.width.equalTo((pictureView?.snp_width)!).offset(0)
        }
        firstScrollView.contentSize.height += detailView.height
    }
    
    //初始化评论视图
    func initEVAView(){
        contentViewForEVAView = UIView()
        firstScrollView.addSubview(contentViewForEVAView)
        contentViewForEVAView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(ContentViewForGoodSizeView.snp_bottom).offset(10)
            make.left.equalTo(ContentViewForGoodSizeView.snp_left).offset(0)
            make.width.equalTo(ContentViewForGoodSizeView.snp_width).offset(0)
        }
        
        let ViewTitle = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
        ViewTitle.backgroundColor = UIColor.whiteColor()
        let LabelTitle = UILabel(frame: CGRect(x: 5, y: 5, width: self.view.frame.width - 5 , height: 20))
        LabelTitle.text = "商品评价"
        ViewTitle.addSubview(LabelTitle)
        let ImageViewArrow = UIImageView(image: UIImage(named: "arrow"))
        ViewTitle.addSubview(ImageViewArrow)
        ImageViewArrow.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(35)
            make.width.equalTo(35)
            make.right.equalTo(ViewTitle.snp_right).offset(0)
            make.top.equalTo(ViewTitle.snp_top).offset(0)
        }
        ViewTitle.addTarget(self, action: "addDetail", forControlEvents: .TouchUpInside)
        contentViewForEVAView.addSubview(ViewTitle)
        var height: CGFloat = 35
        for var x in (item?.comments)!{
            let view1 = EVAView(frame: CGRect(x: 0, y: height + 1, width: self.view.frame.width, height: 70),date: x.date, content: x.content, user: x.userName)
            view1.layoutIfNeeded()
            contentViewForEVAView.addSubview(view1)
            height += view1.frame.height
        }
        
        contentViewForEVAView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(height)
        }
        
        let buttonAddMoreEVA = UIButton(type: .Custom)
        buttonAddMoreEVA.backgroundColor = UIColor.whiteColor()
        buttonAddMoreEVA.setTitle("查看商品详情", forState: .Normal)
        buttonAddMoreEVA.setTitleColor(UIColor.blackColor() , forState: .Normal)
        buttonAddMoreEVA.addTarget(self, action: "addMoreEVA", forControlEvents: .TouchUpInside)
        firstScrollView.addSubview(buttonAddMoreEVA)
        buttonAddMoreEVA.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentViewForEVAView.snp_bottom).offset(10)
            make.left.equalTo(contentViewForEVAView.snp_left).offset(0)
            make.width.equalTo(self.view.frame.width)
        }
        firstScrollView.contentSize.height += height + 150
        print(firstScrollView.contentSize)
        // EVAVC?.view.frame.origin = CGPoint(x: 0, y: (sizeVC?.tableView.frame.origin.y)!  + (sizeVC?.tableViewHeight)! + 10)
    }
    
    //加载更多的评价
    func addMoreEVA(){
        ButtonMenuClicked(ButtonDetail)
    }
    
    func addDetail(){
        ButtonMenuClicked(ButtonEVA)
    }
    
    //初始化规格视图
    func initSizeView(){
        goodSizeView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50), style: .Plain)
        goodSizeView.restorationIdentifier = "GoodSizeView"
        ContentViewForGoodSizeView = UIView()
        firstScrollView.addSubview(ContentViewForGoodSizeView)
        ContentViewForGoodSizeView.addSubview(goodSizeView)
        ContentViewForGoodSizeView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(detailView.snp_bottom).offset(10)
            make.width.equalTo(detailView.snp_width).offset(0)
            make.left.equalTo(detailView.snp_left).offset(0)
        }
        goodSizeView.delegate = self
        goodSizeView.dataSource = self
        goodSizeView.translatesAutoresizingMaskIntoConstraints = false
        goodSizeView.scrollEnabled = false
        goodSizeView.estimatedRowHeight = 80
        goodSizeView.rowHeight = UITableViewAutomaticDimension
        let nib = UINib(nibName: "GoodSizeTableCell", bundle: nil)
        goodSizeView.registerNib(nib, forCellReuseIdentifier: "GoodSizeCell")
    }
    
    //初始化第二个页面
    
    func initSecondView(){
        needLoadSecondView = false
        var counts:CGFloat = 0
        let width = self.view.frame.width
        for var x in (item?.imageDetail)!{
            let imgView = UIImageView(frame: CGRect(x: 0 , y: (width + 10) * counts , width: width, height: width))
            imgView.setImageWithURL(NSURL(string: x))
            imgView.clipsToBounds = true
            counts++
            secondScrollView.contentSize.height += width + 10
            secondScrollView.addSubview(imgView)
        }
    }
    
    //初始化第三个页面
    
    func initThirdView(){
        needloadThirdView = false
        var vc = EVAViewController()
        vc.itemId = item?.itemNo
        self.addChildViewController(vc)
        vc.tableView.frame = CGRect(x: self.view.width * 2, y: 0, width: self.view.width, height: self.view.height - 49 - 59)
        self.scrollView.addSubview(vc.tableView)
    }
    
    
    
}

//tableView代理
extension OtherViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.restorationIdentifier == "GoodSizeView"){
            return data.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        viewDidApper = true
        var cell = tableView.dequeueReusableCellWithIdentifier("GoodSizeCell") as! GoodSizeTableCell
        var buttons = [UIButton]()
        for(var i = 1 ; i < data[indexPath.row].count ; i++ ){
            let button = UIButton(type: .System)
            button.setTitle(data[indexPath.row][i], forState: .Normal)
            button.frame.size        = (data[indexPath.row][i] as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14.0)])
            button.setTitleColor(UIColor.blackColor() , forState: .Normal)
            button.titleLabel?.font  = UIFont.systemFontOfSize(14)
            button.frame.size.width += 15
            button.frame.size.height += 5
            button.setBackgroundImage(UIImage(named: "populartags"), forState: .Normal)
            buttons.append(button)
        }
        cell.sizeTag        = (indexPath.row+1)*100
        cell.buttons        = buttons
        cell.nameLabel.text = data[indexPath.row][0]
        cell.selectionStyle = .None
        prototypeCell = cell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return viewAddNum
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        print("重绘了\(indexPath.row)的高度")
        if(viewDidApper){
            print("yes")
            if(indexPath.row == data.count-1){
                firstScrollView.contentSize.height += tableView.height
                print(firstScrollView.contentSize)
                initEVAView()
                ContentViewForGoodSizeView.snp_makeConstraints(closure: { (make) -> Void in
                    make.height.equalTo(tableView.contentSize.height)
                    contentViewForEVAView.layoutIfNeeded()
                })
            }
            tableView.frame.size.height = tableView.contentSize.height
            return (prototypeCell?.contentView.frame.height)! + 1
        }
        return 10
    }
    
}

//MARK:- scrollView代理
extension OtherViewController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let disx = Int(scrollView.contentOffset.x/self.view.frame.width)+1
        switch(disx){
        case 1: UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.ConstaintViewFlagLeading.constant = 12
        })
        case 2: UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.ConstaintViewFlagLeading.constant = 58
        })
        if( needLoadSecondView){
            initSecondView()
            }
        case 3: UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.ConstaintViewFlagLeading.constant = 105
        })
        if(needloadThirdView){
            initThirdView()
            }
        default: break
        }
    }
}
