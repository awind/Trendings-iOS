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
import ActionSheetPicker_3_0

import Crashlytics

class RepoViewController: UIViewController {
    
    let REPO_CELL = "repoCell"
    
    var language = "All"
    var languageIndex = 0
    var currentIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    var langTitle: UILabel!
    var searchBar: UISearchBar!
    
    var repos = [Repo]()
    var githubRepos = [Repositiory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: language, style: .Plain, target: self, action: #selector(pickerViewClicked))
        
        initTableView()
        self.tableView.mj_header.beginRefreshing()
    }
    
    func initTableView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(pullDownRefresh))
        header.setTitle("Pull down to refresh", forState: .Idle)
        header.setTitle("Release to refresh", forState: .Pulling)
        header.setTitle("Loading", forState: .Refreshing)
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width, 44))
        searchBar.tintColor = UIColor(red: 220/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1.0)
        searchBar.placeholder = "Search Repositiories"
        self.tableView.tableHeaderView = searchBar
        searchBar.delegate = self
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
    
    func getTrendings(language: String, since: String) {
        TrendingAPI.getTrendings(language.lowercaseString, since: since.lowercaseString) { items in
            self.repos = items.items
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
        }
    }
    
    func pullDownRefresh() {
        getTrendings(language.lowercaseString, since: repoSince[currentIndex])
    }
    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == currentIndex  {
            return
        }
        currentIndex = index
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_header.beginRefreshing()
    }
    
}

// MARK: UITableViewDelegate

extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repoCell = tableView.dequeueReusableCellWithIdentifier(REPO_CELL, forIndexPath: indexPath) as! RepoTableViewCell
        let repo = repos[indexPath.row]
        repoCell.bindItem(repo)
        return repoCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repo = repos[indexPath.row]
        let svc = SFSafariViewController(URL: NSURL(string: "https://github.com\(repo.url)")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }

}

// MARK: UISearchControllerDelegate

extension RepoViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let vc = SearchViewController()
        vc.isSearchRepo = true
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true, completion: nil)
        return false
    }
}

