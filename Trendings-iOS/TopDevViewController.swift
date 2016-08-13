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
    
    var languageIndex: Int {
        get {
            if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("topDevLanguageIndex") as? Int {
                return returnValue
            } else {
                return 0
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "topDevLanguageIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var language = topRankSupportLanguages[0]
    
    var locationIndex: Int {
        get {
            if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("topDevLocationIndex") as? Int {
                return returnValue
            } else {
                return 0
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "topDevLocationIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var location = topRankSupportCountryList[0]
    
    var currentPage = 1
    var totalCount = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        language = topRankSupportLanguages[languageIndex]
        location = topRankSupportCountryList[locationIndex]
        self.title = "\(self.language)@\(self.location)"
        initNavigationButtonItem()
        initTableView()
    }
    
    func initNavigationButtonItem() {
        let locationImg = UIImage(named: "ic_location")
        let languageImg = UIImage(named: "ic_code")
        let countryBtn = UIBarButtonItem(image: locationImg, style: .Done, target: self, action: #selector(countrySelect))
        let languageBtn = UIBarButtonItem(image: languageImg, style: .Plain, target: self, action: #selector(languageSelect))
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
        GitHubAPI.topUsers(location.lowercaseString, language: "\(self.language)", page: "\(self.currentPage)", completion: { items in
            self.users.appendContentsOf(items.items)
            self.currentPage += 1
            self.totalCount = items.count
            self.tableViewEndRefresh()
            self.tableView.reloadData()
            }, fail: { error in
                self.tableViewEndRefresh()
        })
    }
    
    func tableViewEndRefresh() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    func countrySelect(sender: UIButton) {
        ActionSheetStringPicker.showPickerWithTitle("Country", rows: topRankSupportCountryList, initialSelection: self.locationIndex, doneBlock: {  picker, value, index in
            if (topRankSupportLanguages[value] == self.language) {
                return
            }
            self.location = topRankSupportCountryList[value]
            self.locationIndex = value
            self.title = "\(self.language)@\(self.location)"
            
            self.tableView.mj_header.beginRefreshing()
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func languageSelect(sender: UIButton) {
        ActionSheetStringPicker.showPickerWithTitle("Language", rows: topRankSupportLanguages, initialSelection: self.languageIndex, doneBlock: {  picker, value, index in
            if (topRankSupportLanguages[value] == self.language) {
                return
            }
            self.language = topRankSupportLanguages[value]
            self.languageIndex = value
            self.title = "\(self.language)@\(self.location)"
            
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
