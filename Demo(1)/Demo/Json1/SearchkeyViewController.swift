//
//  SearchkeyViewController.swift
//  Demo
//
//  Created by jason on 1/25/16.
//  Copyright © 2016 Fjnu. All rights reserved.
//

import UIKit

public protocol SearchkeyViewControllerDelegate: NSObjectProtocol{
   func TheKeyGoToResultViewController(key:String)
}


class SearchkeyViewController: UITableViewController,UISearchResultsUpdating {

    var resultList = [String]()
    var address: String!
    weak var delegate: SearchkeyViewControllerDelegate?
    var filterString: String? = nil{
        didSet{
            if filterString == nil || filterString!.isEmpty{
                
            }else{
                HTTPManager.POST(.SearchResultList, params: ["address": address, "name": filterString!]).responseJSON({ (json) -> Void in
                    self.resultList = json["name"] as! [String]
                    self.tableView.reloadData()
                    }) { (error) -> Void in
                        print("发生了错误: " + (error?.localizedDescription)!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefault = NSUserDefaults()
        address = userDefault.stringForKey("firstLocation")! + "-" + userDefault.stringForKey("secondLocation")! + "-" + userDefault.stringForKey("thirdLocation")!
        
        
        //消除多余的线
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view
        tableView.keyboardDismissMode = .OnDrag
        tableView.bounces = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var  cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if(cell == nil){
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = resultList[indexPath.row]
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let key = resultList[indexPath.row]
        delegate!.TheKeyGoToResultViewController(key)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController){
        
        guard searchController.active else { return }
        
        filterString = searchController.searchBar.text
    }
    

   

}
