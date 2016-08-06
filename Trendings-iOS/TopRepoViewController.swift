//
//  TopViewController.swift
//  Trending
//
//  Created by SongFei on 16/4/29.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import MJRefresh
import ActionSheetPicker_3_0

class TopRepoViewController: UITableViewController {

    let REPO_CELL = "searchRepoCell"
    let USER_CELL = "searchUserCell"
    
    var repos = [Repositiory]()
    var users = [User]()
    
    var language = "All"
    var languageIndex = 0
    var currentPage = 1
    var totalCount = 10
    var isTopRepo = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.language
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(dismissSelf))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: language, style: .Plain, target: self, action: #selector(pickerViewClicked))
        initTableView()
    }
    
    func initTableView() {
        tableView.registerNib(UINib(nibName: "SearchRepoCell", bundle: nil), forCellReuseIdentifier: REPO_CELL)
        tableView.registerNib(UINib(nibName: "SearchUserCell", bundle: nil), forCellReuseIdentifier: USER_CELL)
        
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
        header.setTitle(TrendingString.PULL_DOWN_IDLE_TITLE, forState: .Idle)
        header.setTitle(TrendingString.PULL_DOWN_PULLING_TITLE, forState: .Pulling)
        header.setTitle(TrendingString.PULL_DOWN_REFRESHING_TITLE, forState: .Refreshing)
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(fetchData))
        footer.setTitle(TrendingString.PULL_UP_IDLE_TITLE, forState: .Idle)
        footer.setTitle(TrendingString.PULL_UP_PULLING_TITLE, forState: .Pulling)
        footer.setTitle(TrendingString.PULL_UP_REFRESHING_TITLE, forState: .Refreshing)
        tableView.mj_footer = footer
        tableView.mj_header.beginRefreshing()
        
    }
    
    func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshData() {
        self.currentPage = 1
        self.totalCount = 10
        self.repos.removeAll()
        self.users.removeAll()
        
        if isTopRepo {
            topRepos()
        } else {
            topUsers()
        }
        
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
        if languageIndex == 0 {
            self.language = ""
        }
        GitHubAPI.topRepos("\(self.language)", page: "\(self.currentPage)", completion: { items in
            print(items.count)
            if self.currentPage == 1 {
                self.repos.removeAll()
                self.repos = items.items
            } else {
                self.repos.appendContentsOf(items.items)
            }
            self.currentPage += 1
            self.totalCount = items.count
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            }, fail: { error in
                print("error")
        })
    }
    
    func topUsers() {
        GitHubAPI.topUsers("china", language: "\(self.language)", page: "\(self.currentPage)", completion: { items in
            print(items)
            if self.currentPage == 1 {
                self.users.removeAll()
                self.users = items.items
            } else {
                self.users.appendContentsOf(items.items)
            }
            self.currentPage += 1
            self.totalCount = items.count
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            }, fail: { error in
                print("error")})
    }
    
    func pickerViewClicked(sender: UIButton) {
        ActionSheetStringPicker.showPickerWithTitle("Language", rows: supportLanguages, initialSelection: self.languageIndex, doneBlock: {  picker, value, index in
            if (supportLanguages[value] == self.language) {
                return
            }
            self.language = supportLanguages[value]
            self.languageIndex = value
            
            self.navigationItem.rightBarButtonItem?.title = self.language
            self.tableView.mj_header.beginRefreshing()
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
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

extension TopRepoViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(18.0),
                          NSForegroundColorAttributeName: LIGHT_TEXT_COLOR]
        return NSAttributedString(string: TrendingString.EMPTY_STRING_REPO, attributes: attributes)
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView, forState state: UIControlState) -> NSAttributedString? {
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(16.0),
                          NSForegroundColorAttributeName: state == .Normal ? EMPTY_BUTTON_NORMAL_COLOR : EMPTY_BUTTON_SELECTED_COLOR]
        return NSAttributedString(string: TrendingString.CLICK_TO_REFRESH, attributes: attributes)

    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView) {
        self.refreshData()
    }
}
