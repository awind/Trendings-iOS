//
//  TopViewController.swift
//  Trending
//
//  Created by SongFei on 16/4/29.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import MJRefresh

class TopViewController: UITableViewController {

    let REPO_CELL = "searchRepoCell"
    let USER_CELL = "searchUserCell"
    
    var repos = [Repositiory]()
    var users = [User]()
    
    var currentPage = 1
    var totalCount = 10
    var isTopRepo = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Swift"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(dismissSelf))
        
        tableView.registerNib(UINib(nibName: "SearchRepoCell", bundle: nil), forCellReuseIdentifier: REPO_CELL)
        tableView.registerNib(UINib(nibName: "SearchUserCell", bundle: nil), forCellReuseIdentifier: USER_CELL)
        
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(fetchData))
        footer.setTitle("Pull to refresh", forState: .Idle)
        footer.setTitle("Release to refresh", forState: .Pulling)
        footer.setTitle("Loading", forState: .Refreshing)
        tableView.mj_footer = footer
        fetchData()
    }
    
    func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetchData() {
        
        if currentPage * 10 > totalCount {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        
        if isTopRepo {
            topRepos()
        } else {
            topUsers()
        }
        
    }
    
    func topRepos() {
        GitHubAPI.topRepos("swift", page: "1", completion: { items in
            print(items.count)
            self.repos = items.items
            self.tableView.reloadData()
            }, fail: { error in
                print("error")
        })
    }
    
    func topUsers() {
        GitHubAPI.topUsers("china", language: "java", page: "1", completion: { items in
            print(items)
            self.users = items.items
            self.tableView.reloadData()
            }, fail: { error in
                print("error")})
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTopRepo {
            return repos.count
        }
        return users.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isTopRepo {
            let repo = repos[indexPath.row]
            let repoCell = tableView.dequeueReusableCellWithIdentifier(REPO_CELL, forIndexPath: indexPath) as! SearchRepoCell
            repoCell.bindItem(repo)
            return repoCell
        } else {
            let user = users[indexPath.row]
            let userCell = tableView.dequeueReusableCellWithIdentifier(USER_CELL, forIndexPath: indexPath) as! SearchUserCell
            userCell.bindItem(user)
            return userCell
        }

    }
    
}
