//
//  EVAViewController.swift
//  Demo
//
//  Created by jason on 15/12/7.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class EVAViewController: UITableViewController {

    var comments = [Comment]()
    var itemId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.bounces = false
    }
    
    
    func loadData(){
        
        HTTPManager.POST(ContentType.ItemComment, params: ["itemno":itemId]).responseJSON({(json) -> Void in
            print(json)
            let arry = (json["comments"] as? NSDictionary)!["list"] as? NSArray
            if(arry?.count != 0){
                for var x in arry!{
                    var xx = x as! NSDictionary
                    self.comments.append(Comment(content: xx["comment"] as? String, date: xx["commentDate"] as? String, userName: xx["custNo"] as? String))
                }
            }
            self.tableView.reloadData()
            }) { (error) -> Void in
                print("发生了错误: " + (error?.localizedDescription)!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return comments.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch(indexPath.row){
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("titleCell")
            if( cell == nil){
                cell = UITableViewCell(style: .Value1, reuseIdentifier: "titleCell")
            }
            cell?.textLabel?.text = comments[indexPath.section].userName
            cell?.detailTextLabel?.text = comments[indexPath.section].date
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("contentCell")
            if( cell == nil){
                cell = UITableViewCell(style: .Default, reuseIdentifier: "contentCell")
            }
            cell?.textLabel?.text = comments[indexPath.section].content
        default: break;
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
