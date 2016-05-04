//
//  UserViewController.swift
//  Trending
//
//  Created by SongFei on 16/5/4.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import SafariServices
import MJRefresh
import MBProgressHUD

class UserSearchViewController: UITableViewController {
    
    let DEFAULT_CELL = "cell"
    let USER_CELL = "searchUserCell"
    
    var users = [User]()
    
    var currentPage = 1
    var totalCount = 10
    var keyword: String = "" {
        
        didSet{
            self.users.removeAll()
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
        
        tableView.registerNib(UINib(nibName: "SearchUserCell", bundle: nil), forCellReuseIdentifier: USER_CELL)
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
        self.users.removeAll()
        self.tableView.reloadData()
        currentPage = 1
        totalCount = 10
        searchUsers()
    }
    
}

extension UserSearchViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        let userCell = tableView.dequeueReusableCellWithIdentifier(USER_CELL, forIndexPath: indexPath) as! SearchUserCell
        userCell.bindItem(user)
        return userCell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var svc: SFSafariViewController
        let user = users[indexPath.row]
        svc = SFSafariViewController(URL: NSURL(string: user.url)!)
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
        searchUsers()
    }
    
    
    func searchUsers() {
        GitHubAPI.searchUsers(self.keyword, page: "\(currentPage)", completion: { items in
            self.tableView.mj_footer.endRefreshing()
            self.tableView.mj_header.endRefreshing()
            if self.currentPage == 1 {
                self.users.removeAll()
                self.users = items.items
            } else {
                self.users += items.items
            }
            self.currentPage += 1
            self.totalCount = items.count
            self.tableView.reloadData()
//            self.hud.hide(true)
            }, fail: { error in
                self.tableView.mj_footer.endRefreshing()
//                self.hud.labelText = "Loading Error"
//                self.hud.hide(true, afterDelay: 1)
                
        })
    }
    
}

