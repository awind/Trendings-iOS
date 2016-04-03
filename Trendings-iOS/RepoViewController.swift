//
//  ViewController.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/3/27.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import SafariServices
import MJRefresh

class RepoViewController: UIViewController {

    let CELL = "repoCell"
    
    var language = "all"
    let sinceArray = ["daily", "weekly", "monthly"]
    var currentIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    var repos = [Repo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repositiories"
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(pullDownRefresh))
        header.setTitle("Pull down to refresg", forState: .Idle)
        header.setTitle("Release_to_refresh", forState: .Pulling)
        header.setTitle("Loading", forState: .Refreshing)
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.mj_header.beginRefreshing()
        getTrendings(language, since: "daily")
    }
    
    func getTrendings(language: String, since: String) {
        TrendingAPI.getTrendings(language, since: since) { items in
            self.repos = items.items
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func pullDownRefresh() {
        self.tableView.mj_header.beginRefreshing()
        getTrendings(language, since: sinceArray[currentIndex])
    }

    @IBAction func segmentIndexChange(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == currentIndex  {
            return
        }
        currentIndex = index
        switch index {
        case 0:
            getTrendings(language, since: sinceArray[0])
        case 1:
            getTrendings(language, since: sinceArray[1])
        case 2:
            getTrendings(language, since: sinceArray[2])
        default:
            break
        }
    }

}

extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repo = repos[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL, forIndexPath: indexPath) as! RepoTableViewCell
        
        cell.title.text = "\(repo.owner)\(repo.name)"
        cell.desc.text = "\(repo.description)"
        cell.star.text = "\(repo.star)"
        cell.lang.kf_setImageWithURL(NSURL(string: "http://7xs2pw.com1.z0.glb.clouddn.com/\(repo.language.lowercaseString).png")!)
        cell.addContributor(repo.contributors)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repo = repos[indexPath.row]
        let svc = SFSafariViewController(URL: NSURL(string: "https://github.com\(repo.url)")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
}

