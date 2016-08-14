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
import SafariServices

class TopRepoViewController: UITableViewController {

    let REPO_CELL = "topRepoTableViewCell"
    
    var repos = [Repositiory]()
    
    var languageIndex: Int {
        get {
            if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("topRepoLanguageIndex") as? Int {
                return returnValue
            } else {
                return 0
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "topRepoLanguageIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var language = topRankSupportLanguages[0]
    
    var currentPage = 1
    var totalCount = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        language = topRankSupportLanguages[languageIndex]
        self.title = self.language
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_code.png"), style: .Plain, target: self, action: #selector(pickerViewClicked))
        initTableView()
    }
    
    func initTableView() {
        tableView.registerNib(UINib(nibName: "TopRepoTableViewCell", bundle: nil), forCellReuseIdentifier: REPO_CELL)
        
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
        currentPage = 1
        totalCount = 10
        repos = []
        tableView.reloadData()
        topRepos()
    }
    
    func fetchData() {
        if currentPage * 10 > totalCount {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        topRepos()
    }
    
    func topRepos() {
        GitHubAPI.topRepos("\(language)", page: "\(currentPage)", completion: { items in
            //print(items.count)
            self.repos.appendContentsOf(items.items)
            self.currentPage += 1
            self.totalCount = items.count
            self.tableViewEndRefresh()
            self.tableView.reloadData()
            }, fail: { error in
                FabricEvent.logCustomEvent(TrendingString.ERROR_GITHUB_API)
                self.tableViewEndRefresh()
                
        })
    }
    
    func tableViewEndRefresh() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    func pickerViewClicked(sender: UIButton) {
        ActionSheetStringPicker.showPickerWithTitle("Language", rows: topRankSupportLanguages, initialSelection: self.languageIndex, doneBlock: {  picker, value, index in
            if (topRankSupportLanguages[value] == self.language) {
                return
            }
            self.language = topRankSupportLanguages[value]
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
        return repos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repo = repos[indexPath.row]
        let repoCell = tableView.dequeueReusableCellWithIdentifier(REPO_CELL, forIndexPath: indexPath) as! TopRepoTableViewCell
        repoCell.bindItem(repo, indexPath: indexPath)
        return repoCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repo = repos[indexPath.row]
        let safraiVC = SFSafariViewController(URL: NSURL(string: repo.url)!)
        self.presentViewController(safraiVC, animated: true, completion: nil)
        FabricEvent.logContentViewEvent(String(TopRepoViewController.self), type: TrendingString.EVENT_CONTENT_VIEW_TYPE_SAFARI, contentId: repo.fullname)
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
