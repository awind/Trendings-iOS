//
//  DevloperViewController.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/4/1.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import Kingfisher

class DevloperViewController: UIViewController {

    let CELL = "devCell"
    
    var devItems = [Developers]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 93.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        getDevelopers("swift", since: "daily")
    }

    func getDevelopers(language: String, since: String) {
        TrendingAPI.getDevelopers(language, since: since) { items in
            self.devItems = items.items
            self.tableView.reloadData()
        }
    }
}

extension DevloperViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devItems.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = devItems[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL, forIndexPath: indexPath) as! DevTableViewCell
        
        cell.name.text = item.loginName
        cell.rank.text = "\(item.rank)"
        cell.repoName.text = item.repoName
        cell.repoDesc.text = item.repoDesc
        cell.avatar.kf_setImageWithURL(NSURL(string: item.avatar)!)
        return cell
    }

}
