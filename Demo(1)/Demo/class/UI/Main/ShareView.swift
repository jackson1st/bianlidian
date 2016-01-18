//
//  ShareView.swift
//  SmallDay

//  自定义分享view

import UIKit

class ShareView: UIView {
    weak var shareVC: UIViewController?
    var shareModel: ShareModel?
    
    private lazy var coverBtn: UIButton! = {
        let coverBtn = UIButton(frame: MainBounds)
        coverBtn.backgroundColor = UIColor.blackColor()
        coverBtn.alpha = 0.2
        coverBtn.addTarget(self, action: "coverClick", forControlEvents: UIControlEvents.TouchUpInside)
        return coverBtn
        }()
    
    class func shareViewFromXib() -> ShareView {
        let shareV = NSBundle.mainBundle().loadNibNamed("ShareView", owner: nil, options: nil).last as! ShareView
        shareV.frame = CGRectMake(0, AppHeight, AppWidth, theme.ShareViewHeight)
        return shareV
    }
 
    @IBAction func weChat(sender: AnyObject) {
        hideShareView()
//        ShareTool.shareToWeChat(self.shareModel!)
    }
    
    @IBAction func friends(sender: AnyObject) {
        hideShareView()
//        ShareTool.shareToWeChatFriends(self.shareModel!)
    }
    
    @IBAction func sina(sender: AnyObject) {
        hideShareView()
        ShareTool.shareToSina(self.shareModel!, viewController: shareVC)
    }
    
    @IBAction func cancle(sender: AnyObject) {
        hideShareView()
    }

    func showShareView(rect: CGRect) {
        self.superview?.insertSubview(coverBtn, belowSubview: self)
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.frame = rect
        })
    }
    
    func hideShareView() {
        coverBtn.removeFromSuperview()
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.frame = CGRectMake(0, AppHeight, AppWidth, theme.ShareViewHeight)
        }) { (finsch) -> Void in
            self.removeFromSuperview()
        }
    }
    
    func coverClick()  {
        hideShareView()
    }
}
