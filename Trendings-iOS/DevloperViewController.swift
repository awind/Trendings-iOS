//
//  DevloperViewController.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/4/1.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import SafariServices
import Kingfisher
import MJRefresh
import BTNavigationDropdownMenu
import Crashlytics

class DevloperViewController: UIViewController {

    let DEVELOPER_CELL = "devCell"
    let SEGMENTED_CELL = "segmented"
    
    var language = "All"
    let supportLanguages = ["All", "Java", "Objective-C", "JavaScript", "Python", "Swift", "Ruby", "Php", "Shell", "Go", "C", "Cpp"]
    let sinceArray = ["daily", "weekly", "monthly"]
    var currentIndex = 0
    
    var devItems = [Developers]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        initMenuView()
        initTableView()
        
        self.tableView.mj_header.beginRefreshing()
        getDevelopers(language, since: "daily")
    }
    
    func initMenuView() {
        
        let parentVC = self.parentViewController as! UINavigationController
        let menuView = BTNavigationDropdownMenu(navigationController: parentVC, title: "\(self.language)", items: supportLanguages)
        menuView.cellSeparatorColor = UIColor.init(red: 136, green: 136, blue: 136, alpha: 1)
        menuView.arrowImage = UIImage(named: "ic_arrow_down.png")
        menuView.checkMarkImage = UIImage(named: "ic_check.png")
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            self.language = self.supportLanguages[indexPath].lowercaseString
            self.tableView.mj_header.beginRefreshing()
        }
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellTextLabelColor = UIColor.darkGrayColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        self.navigationItem.titleView = menuView
    }
    
    func initTableView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(pullDownRefresh))
        header.setTitle("Pull down to refresg", forState: .Idle)
        header.setTitle("Release_to_refresh", forState: .Pulling)
        header.setTitle("Loading", forState: .Refreshing)
        header.lastUpdatedTimeLabel?.hidden = true
        
        self.tableView.mj_header = header
        
        tableView.estimatedRowHeight = 93.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func getDevelopers(language: String, since: String) {
        TrendingAPI.getDevelopers(language.lowercaseString, since: since.lowercaseString) { items in
            self.devItems = items.items
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: .Top, animated: true)
        }
    }
    
    func pullDownRefresh() {
        getDevelopers(language, since: sinceArray[currentIndex])
    }

    
    func segmentValueChanged(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == currentIndex {
            return
        }
        currentIndex = index
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_header.beginRefreshing()
    }
}

extension DevloperViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devItems.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var identifier = DEVELOPER_CELL
        if indexPath.row == 0 {
            identifier = SEGMENTED_CELL
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        if let devCell = cell as? DevTableViewCell {
            let item = devItems[indexPath.row - 1]
            let attributeString = NSMutableAttributedString(string: "\(item.loginName)")
            let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(16), NSForegroundColorAttributeName: UIColor.blackColor()]
            attributeString.appendAttributedString(NSAttributedString(string: item.fullName, attributes: attrs))
            devCell.name.attributedText = attributeString
            
            devCell.rank.text = "\(item.rank)"
            devCell.repoName.text = "\(item.repoName)  \(item.repoDesc)"
            devCell.avatar.kf_setImageWithURL(NSURL(string: item.avatar)!)
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
        let item = self.devItems[indexPath.row - 1]
        let svc = SFSafariViewController(URL: NSURL(string: "https://github.com\(item.url)")!)
        self.presentViewController(svc, animated: true, completion: nil)
        
        Answers.logContentViewWithName("ViewContent", contentType: "Developers", contentId: item.url, customAttributes: nil)
    }

}
