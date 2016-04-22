//
//  ViewController.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/3/27.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
import MJRefresh
import ActionSheetPicker_3_0

import Crashlytics

class RepoViewController: UIViewController {
    
    let REPO_CELL = "repoCell"
//    let SEARCH_REPO_CELL = "searchRepoCell"
    
    var language = "All"
    var languageIndex = 0
    var currentIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar!
    
    var repos = [Repo]()
    var githubRepos = [Repositiory]()
    
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
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width, 44))
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
//        if self.searchController.active {
//            return githubRepos.count
//        }
        return repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repoCell = tableView.dequeueReusableCellWithIdentifier(REPO_CELL, forIndexPath: indexPath) as! RepoTableViewCell
        
        let repo = repos[indexPath.row]
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
        if self.language.lowercaseString != "all" {
            repoCell.lang.hidden = true
        } else {
            repoCell.lang.hidden = false
        }
        
//        if let githubCell = cell as? SearchRepoTableViewCell {
//            let repo = githubRepos[indexPath.row]
//            let attributeString = NSMutableAttributedString(string: "\(repo.owner.login)/")
//            let attrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(16)]
//            attributeString.appendAttributedString(NSAttributedString(string: repo.name, attributes: attrs))
//            githubCell.repoName.attributedText = attributeString
//            
//            githubCell.desc.text = "\(repo.description)"
//            if repo.language != nil {
//                githubCell.lang.text = "\(repo.language!)"
//            } else {
//                githubCell.lang.text = "Unknown"
//            }
//            githubCell.stars.text = "\(repo.stars)"
//            githubCell.avatar.kf_setImageWithURL(NSURL(string: "\(repo.owner.avatarUrl)")!, placeholderImage: UIImage(named: "ic_all.png"))
//            
//        }
        
        return repoCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.row > 0 else {
            return
        }
        let repo = repos[indexPath.row]
        let svc = SFSafariViewController(URL: NSURL(string: "https://github.com\(repo.url)")!)
        self.presentViewController(svc, animated: true, completion: nil)
        
        Answers.logContentViewWithName("ViewContent", contentType: "Repo", contentId: repo.url, customAttributes: nil)
        
    }

}

// MARK: UISearchControllerDelegate

extension RepoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        let vc = SearchViewController()
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true, completion: nil)
    }
}

