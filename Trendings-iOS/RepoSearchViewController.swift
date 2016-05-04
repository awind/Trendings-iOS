//
//  RepoSearchViewController.swift
//  Trending
//
//  Created by SongFei on 16/5/4.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import SafariServices
import MJRefresh
import MBProgressHUD

class RepoSearchViewController: UITableViewController {
    
    let DEFAULT_CELL = "cell"
    let REPO_CELL = "searchRepoCell"
    
    var repos = [Repositiory]()
    
    var currentPage = 1
    var totalCount = 10
    var keyword: String = "" {
        
        didSet{
            self.repos.removeAll()
            self.tableView.reloadData()
            currentPage = 1
            totalCount = 10
            self.tableView.mj_header.hidden = false
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    var parentNavigationController: UINavigationController?
    
    var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        
        tableView.registerNib(UINib(nibName: "SearchRepoCell", bundle: nil), forCellReuseIdentifier: REPO_CELL)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: DEFAULT_CELL)
        
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(pullDownRefresh))
        header.setTitle("Pull down to refresh", forState: .Idle)
        header.setTitle("Release to refresh", forState: .Pulling)
        header.setTitle("Loading", forState: .Refreshing)
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(fetchData))
        footer.setTitle("Pull to refresh", forState: .Idle)
        footer.setTitle("Release to refresh", forState: .Pulling)
        footer.setTitle("Loading", forState: .Refreshing)
        tableView.mj_footer = footer
    }
    
    func pullDownRefresh() {
        self.repos.removeAll()
        self.tableView.reloadData()
        currentPage = 1
        totalCount = 10
        searchRepos()
    }
    
}

extension RepoSearchViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let repo = repos[indexPath.row]
        let repoCell = tableView.dequeueReusableCellWithIdentifier(REPO_CELL, forIndexPath: indexPath) as! SearchRepoCell
        repoCell.bindItem(repo)
        return repoCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var svc: SFSafariViewController
        let repo = repos[indexPath.row]
        svc = SFSafariViewController(URL: NSURL(string: repo.url)!)
        self.parentNavigationController?.presentViewController(svc, animated: true, completion: nil)
    }
    
    
    func fetchData() {
        if self.keyword.isEmpty {
            tableView.mj_footer.endRefreshing()
            return
        }
        
        if currentPage * 10 > totalCount {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        
        searchRepos()
    }
    
    func searchRepos() {
        GitHubAPI.searchRepos(self.keyword, page: "\(currentPage)", completion: { items in
            self.tableView.mj_footer.endRefreshing()
            self.tableView.mj_header.endRefreshing()
            if self.currentPage == 1 {
                self.repos.removeAll()
                self.repos = items.items
            } else {
                self.repos += items.items
            }
            self.currentPage += 1
            self.totalCount = items.count
            self.tableView.reloadData()
            //            self.hud.hide(true)
            }, fail:  { error in
                self.tableView.mj_footer.endRefreshing()
                //                self.hud.labelText = "Loading Error"
                //                self.hud.hide(true, afterDelay: 1)
        })
    }
    
    
}
