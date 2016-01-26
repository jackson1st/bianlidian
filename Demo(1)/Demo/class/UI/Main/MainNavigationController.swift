//


import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer!.delegate = nil;
    }
    
    lazy var backBtn: UIButton = {
        //设置返回按钮属性
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        backBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        backBtn.setImage(UIImage(named: "back_2"), forState: .Normal)
        backBtn.setImage(UIImage(named: "back_2"), forState: .Highlighted)
        backBtn.addTarget(self, action: "backBtnClick", forControlEvents: .TouchUpInside)
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0)
        backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        let btnW: CGFloat = AppWidth > 375.0 ? 50 : 44
        backBtn.frame = CGRectMake(0, 0, btnW, 40)
        return backBtn
        }()
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        if self.childViewControllers.count > 0 {
            let vc = self.childViewControllers[0]
            
            if self.childViewControllers.count == 1 {
                backBtn.setTitle("我的", forState: .Normal)
            } else {
                backBtn.setTitle("返回", forState: .Normal)
            }
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    func backBtnClick() {
        self.popViewControllerAnimated(true)
    }
    
}