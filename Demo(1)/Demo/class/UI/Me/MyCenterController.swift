//
//  MyCenterController.swift
//  Demo
//
//  Created by mac on 16/1/23.
//  Copyright © 2016年 Fjnu. All rights reserved.
//

import UIKit

class MyCenterController: UITableViewController {
    
    @IBOutlet var iconImageView: UIImageView!
    override func viewDidLoad() {
        prepareUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        setNavigation()
    }
    func prepareUI(){
        setTableViewHeader()
        setNavigation()
        
    }
    
    func setNavigation(){
        
    }
    func setTableViewHeader(){
        
        iconImageView.userInteractionEnabled = true
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 32.5
        //添加tableHeaderView
        tableView.frame = CGRect(x: 0, y: 0, width: AppWidth, height: AppHeight)
    }

}

extension MyCenterController {
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}