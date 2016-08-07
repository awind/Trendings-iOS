//
//  TopDevViewController.swift
//  Trending
//
//  Created by Song, Phillip on 8/6/16.
//  Copyright © 2016 SongFei. All rights reserved.
//

import UIKit
import MJRefresh
import ActionSheetPicker_3_0
import SafariServices

class TopDevViewController: UITableViewController {

    let USER_CELL = "topRankDevCell"
    
    var users = [User]()
    
    var language = "All"
    var languageIndex = 0
    var currentPage = 1
    var totalCount = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.language
        initNavigationButtonItem()
        initTableView()
    }
    
    func initNavigationButtonItem() {
        let countryImg = UIImage(named: "ic_share")
        let languageImg = UIImage(named: "ic_star")
        let countryBtn = UIBarButtonItem(image: countryImg, style: .Plain, target: self, action: #selector(countrySelect))
        let languageBtn = UIBarButtonItem(image: languageImg, style: .Plain, target: self, action: #selector(pickerViewClicked))
        self.navigationItem.rightBarButtonItems = [languageBtn, countryBtn]
    }
    
    func initTableView() {
        tableView.registerNib(UINib(nibName: "TopUserTableViewCell", bundle: nil), forCellReuseIdentifier: USER_CELL)
        
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
        header.setTitle(TrendingString.PULL_DOWN_IDLE_TITLE, forState: .Idle)
        header.setTitle(TrendingString.PULL_DOWN_PULLING_TITLE, forState: .Pulling)
        header.setTitle(TrendingString.PULL_DOWN_REFRESHING_TITLE, forState: .Refreshing)
        header.lastUpdatedTimeLabel?.hidden = true
        tableView.mj_header = header
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(fetchData))
        footer.setTitle(TrendingString.PULL_UP_IDLE_TITLE, forState: .Idle)
        footer.setTitle(TrendingString.PULL_UP_PULLING_TITLE, forState: .Pulling)
        footer.setTitle(TrendingString.PULL_UP_REFRESHING_TITLE, forState: .Refreshing)
        tableView.mj_footer = footer
        tableView.mj_header.beginRefreshing()
    }
    
    func countrySelect(sender: UIButton) {
        
    }
    
    func refreshData() {
        currentPage = 1
        totalCount = 10
        users = []
        tableView.reloadData()
        topUsers()
    }
    
    func fetchData() {
        if currentPage * 10 > totalCount {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        
        topUsers()
    }
    
    func topUsers() {
        GitHubAPI.topUsers("china", language: "\(self.language)", page: "\(self.currentPage)", completion: { items in
            self.users.appendContentsOf(items.items)
            self.currentPage += 1
            self.totalCount = items.count
            self.tableViewEndRefresh()
            self.tableView.reloadData()
            }, fail: { error in
                // TODO
                self.tableViewEndRefresh()
        })
    }
    
    func tableViewEndRefresh() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    func pickerViewClicked(sender: UIButton) {
        ActionSheetStringPicker.showPickerWithTitle("Language", rows: supportLanguages, initialSelection: self.languageIndex, doneBlock: {  picker, value, index in
            if (supportLanguages[value] == self.language) {
                return
            }
            self.language = supportLanguages[value]
            self.languageIndex = value
            self.title = self.language
            
            self.tableView.mj_header.beginRefreshing()
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let userCell = tableView.dequeueReusableCellWithIdentifier(USER_CELL, forIndexPath: indexPath) as! TopUserTableViewCell
        userCell.bindItem(user, indexPath: indexPath)
        return userCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = users[indexPath.row]
        let svc = SFSafariViewController(URL: NSURL(string: user.url)!)
        self.presentViewController(svc, animated: true, completion: nil)
    }

}
