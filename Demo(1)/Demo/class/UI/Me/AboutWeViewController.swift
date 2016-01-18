//
//  AboutWeViewController.swift
//  SmallDay

//  关于我们

import UIKit

class AboutWeViewController: UIViewController {

    init() {
        super.init(nibName: "AboutWeViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "AboutWeViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "关于我们"
//        self.tabBarController!.tabBar.hidden = true
    }
}
