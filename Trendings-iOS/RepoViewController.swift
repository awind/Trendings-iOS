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
import BTNavigationDropdownMenu
import Crashlytics

class RepoViewController: UIViewController {

    let REPO_CELL = "repoCell"
    let SEGMENTED_CELL = "segmented"
    
    var language = "All"
    let supportLanguages = ["All", "Java", "Objective-C", "JavaScript", "Python", "Swift", "Ruby", "Php", "Shell", "Go", "C", "Cpp"]
    let sinceArray = ["daily", "weekly", "monthly"]
    var currentIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    var repos = [Repo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        initMenuView()

        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(pullDownRefresh))
        header.setTitle("Pull down to refresg", forState: .Idle)
        header.setTitle("Release_to_refresh", forState: .Pulling)
        header.setTitle("Loading", forState: .Refreshing)
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.mj_header.beginRefreshing()
        getTrendings(language, since: "daily")
    }
    
    func initMenuView() {
        let parentVC = self.parentViewController as! UINavigationController
        let menuView = BTNavigationDropdownMenu(navigationController: parentVC, title: self.language, items: supportLanguages)
        menuView.cellSeparatorColor = UIColor.init(red: 136, green: 136, blue: 136, alpha: 1)
        menuView.arrowImage = UIImage(named: "ic_arrow_down.png")
        menuView.checkMarkImage = UIImage(named: "ic_check.png")
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            self.language = self.supportLanguages[indexPath].lowercaseString
            self.title = "Repositiories"
            self.pullDownRefresh()
        }
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellTextLabelColor = UIColor.darkGrayColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.animationDuration = 0.3
        self.navigationItem.titleView = menuView
    }
    
    func getTrendings(language: String, since: String) {
        TrendingAPI.getTrendings(language.lowercaseString, since: since.lowercaseString) { items in
            self.repos = items.items
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: .Top, animated: true)
        }
    }
    
    func pullDownRefresh() {
        self.tableView.mj_header.beginRefreshing()
        getTrendings(language, since: sinceArray[currentIndex])
    }

    func segmentValueChanged(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == currentIndex  {
            return
        }
        currentIndex = index
        pullDownRefresh()
    }

}

extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var identifier = REPO_CELL
        if indexPath.row == 0 {
            identifier = SEGMENTED_CELL
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        if let repoCell = cell as? RepoTableViewCell  {
            let repo = repos[indexPath.row - 1]
            let attributeString = NSMutableAttributedString(string: "\(repo.owner)/")
            let attrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(16)]
            attributeString.appendAttributedString(NSAttributedString(string: repo.name, attributes: attrs))
            repoCell.title.attributedText = attributeString
            
            repoCell.desc.text = "\(repo.description)"
            repoCell.star.text = "\(repo.star)"
            repoCell.addContributor(repo.contributors)
            if !repo.language.isEmpty {
                let language = repo.language.replace(" ", replacement: "-").lowercaseString
                repoCell.lang.kf_setImageWithURL(NSURL(string: "http://7xs2pw.com1.z0.glb.clouddn.com/\(language).png")!, placeholderImage: UIImage(named: "ic_all.png"))
            }
            if self.language != "All" {
                repoCell.lang.hidden = true
            }
        }
    
        if let segmentedCell = cell as? SegmentedTableViewCell {
            segmentedCell.segmentedControl.addTarget(self, action: #selector(segmentValueChanged), forControlEvents: .ValueChanged)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.row > 0 else {
            return
        }
        let repo = repos[indexPath.row - 1]
        let svc = SFSafariViewController(URL: NSURL(string: "https://github.com\(repo.url)")!)
        self.presentViewController(svc, animated: true, completion: nil)
        
        Answers.logContentViewWithName("ViewContent", contentType: "Repo", contentId: repo.url, customAttributes: nil)

    }
    
}

