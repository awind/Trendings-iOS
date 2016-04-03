//
//  DevloperViewController.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/4/1.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import SafariServices
import Kingfisher
import MJRefresh

class DevloperViewController: UIViewController {

    let CELL = "devCell"
    
    var language = "all"
    let sinceArray = ["daily", "weekly", "monthly"]
    var currentIndex = 0
    
    var devItems = [Developers]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(pullDownRefresh))
        header.setTitle("Pull down to refresg", forState: .Idle)
        header.setTitle("Release_to_refresh", forState: .Pulling)
        header.setTitle("Loading", forState: .Refreshing)
        header.lastUpdatedTimeLabel?.hidden = true
        
        self.tableView.mj_header = header

        tableView.estimatedRowHeight = 93.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.mj_header.beginRefreshing()
        getDevelopers(language, since: "daily")
    }
    
    func getDevelopers(language: String, since: String) {
        TrendingAPI.getDevelopers(language, since: since) { items in
            self.devItems = items.items
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func pullDownRefresh() {
        self.tableView.mj_header.beginRefreshing()
        getDevelopers(language, since: sinceArray[currentIndex])
    }

    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == currentIndex {
            return
        }
        currentIndex = index
        switch index {
        case 0:
            getDevelopers(language, since: sinceArray[0])
        case 1:
            getDevelopers(language, since: sinceArray[1])
        case 2:
            getDevelopers(language, since: sinceArray[2])
        default:
            break
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.devItems[indexPath.row]
        let svc = SFSafariViewController(URL: NSURL(string: "https://github.com\(item.url)")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }

}
