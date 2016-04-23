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
import Alamofire
import Crashlytics
import ActionSheetPicker_3_0

class DevloperViewController: UIViewController {
    
    let DEVELOPER_CELL = "devCell"
    
    var language = "All"
    var languageIndex = 0
    var currentIndex = 0
    
    var devItems = [Developer]()
    
    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_arrow_down.png"), style: .Plain, target: self, action: #selector(pickerViewClicked))
        
        initTableView()
        
        self.tableView.mj_header.beginRefreshing()
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
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width, 44))
        searchBar.tintColor = UIColor(red: 220/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1.0)
        searchBar.placeholder = "Search Users"
        self.tableView.tableHeaderView = searchBar
        searchBar.delegate = self
    }
    
    func getDevelopers(language: String, since: String) {
        TrendingAPI.getDevelopers(language.lowercaseString, since: since.lowercaseString) { items in
            self.devItems = items.items
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
        }
    }
    
    func pickerViewClicked(sender: UIButton) {
        ActionSheetStringPicker.showPickerWithTitle("Language", rows: supportLanguages, initialSelection: self.languageIndex, doneBlock: {  picker, value, index in
            if (supportLanguages[value] == self.language) {
                return
            }
            self.language = supportLanguages[value]
            self.languageIndex = value
            self.tableView.mj_header.beginRefreshing()
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func pullDownRefresh() {
        getDevelopers(language.lowercaseString, since: devSince[currentIndex])
    }
    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
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
        let devCell = tableView.dequeueReusableCellWithIdentifier(DEVELOPER_CELL, forIndexPath: indexPath) as! DevTableViewCell
        
        let item = devItems[indexPath.row]
        devCell.bindItem(item)
        
        return devCell
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

// MARK: UISearchControllerDelegate

extension DevloperViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let vc = SearchViewController()
        vc.isSearchRepo = false
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true, completion: nil)
        return false
    }
}
