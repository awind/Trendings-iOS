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

class DevloperViewController: UIViewController {

    let CELL = "devCell"
    
    var language = "all"
    var currentIndex = 0
    
    var devItems = [Developers]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Developers"
        tableView.estimatedRowHeight = 93.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        getDevelopers(language, since: "daily")
    }
    
    func getDevelopers(language: String, since: String) {
        TrendingAPI.getDevelopers(language, since: since) { items in
            self.devItems = items.items
            self.tableView.reloadData()
        }
    }

    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == currentIndex {
            return
        }
        currentIndex = index
        switch index {
        case 0:
            getDevelopers(language, since: "daily")
        case 1:
            getDevelopers(language, since: "weekly")
        case 2:
            getDevelopers(language, since: "monthly")
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
