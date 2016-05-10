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
    
    var language: String {
        get {
            if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("repoLanguage") as? String {
                return returnValue
            } else {
                return "All"
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "repoLanguage")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.tableView.mj_header.beginRefreshing()
        }
    }
    var languageIndex: Int {
        get {
            if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("repoLanguageIndex") as? Int {
                return returnValue
            } else {
                return 0
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "repoLanguageIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    var sinceIndex: Int {
        get {
            if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("repoSinceIndex") as? Int {
                return returnValue
            } else {
                return 0
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "repoSinceIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var repos = [Repo]()
    var githubRepos = [Repositiory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.prompt = self.language
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        self.segmentedControl.selectedSegmentIndex = self.sinceIndex
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_arrow_down.png"), style: .Plain, target: self, action: #selector(pickerViewClicked))
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
    }
    
    func pickerViewClicked(sender: UIButton) {
        ActionSheetStringPicker.showPickerWithTitle("Language", rows: supportLanguages, initialSelection: self.languageIndex, doneBlock: {  picker, value, index in
            if (supportLanguages[value] == self.language) {
                return
            }
            self.language = supportLanguages[value]
            self.languageIndex = value
            self.navigationItem.prompt = self.language
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
        getTrendings(language.lowercaseString, since: repoSince[sinceIndex])
    }
    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == sinceIndex  {
            return
        }
        sinceIndex = index
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
