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
    let SEGMENTED_CELL = "segmented"
    
    var language = "All"
    var languageIndex = 0
    var currentIndex = 0
    
    var devItems = [Developers]()
    
    @IBOutlet weak var tableView: UITableView!
    let titleLabel = UILabel(frame: CGRectMake(0, 0, screenWidth - 120, 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = self.language
        self.navigationItem.titleView = titleLabel
        
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
        
    }
    
    func getDevelopers(language: String, since: String) {
        TrendingAPI.getDevelopers(language.lowercaseString, since: since.lowercaseString) { items in
            self.devItems = items.items
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: .Top, animated: true)
        }
    }
    
    func pickerViewClicked(sender: UIButton) {
        ActionSheetStringPicker.showPickerWithTitle("Language", rows: supportLanguages, initialSelection: self.languageIndex, doneBlock: {  picker, value, index in
            if (supportLanguages[value] == self.language) {
                return
            }
            self.language = supportLanguages[value]
            self.languageIndex = value
            self.titleLabel.text = self.language
            self.tableView.mj_header.beginRefreshing()
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func pullDownRefresh() {
        getDevelopers(language.lowercaseString, since: devSince[currentIndex])
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
        return self.devItems.count + 1
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
