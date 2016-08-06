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

class UserSearchViewController: UITableViewController {
    
    let DEFAULT_CELL = "cell"
    let USER_CELL = "searchUserCell"
    
    var users = [User]()
    
    var isLoading = false
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
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
    }
    
    func pullDownRefresh() {
        self.users.removeAll()
        self.tableView.reloadData()
        currentPage = 1
        totalCount = 10
        if self.keyword.isEmpty {
            self.tableView.mj_header.endRefreshing()
            return
        }
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
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.users.count - 4 {
            fetchData()
        }
    }
    
    
    func fetchData() {
        if self.keyword.isEmpty {
            return
        }
        
        if isLoading {
            return
        }
        
        if currentPage * 10 > totalCount {
            return
        }
        self.isLoading = true
        searchUsers()
    }
    
    
    func searchUsers() {
        GitHubAPI.searchUsers(self.keyword, page: "\(currentPage)", completion: { items in
            self.isLoading = false
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
            }, fail: { error in
                self.isLoading = false
        })
    }
    
}

extension UserSearchViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(18.0),
                          NSForegroundColorAttributeName: LIGHT_TEXT_COLOR]
        return NSAttributedString(string: TrendingString.EMPTY_STRING_SEARCH_DEV, attributes: attributes)
    }
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView) -> Bool {
        return true
    }
}

