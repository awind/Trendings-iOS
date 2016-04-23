//
//  SearchViewController.swift
//  Trending
//
//  Created by SongFei on 16/4/22.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import MJRefresh

class SearchViewController: UITableViewController {
    
    let REPO_CELL = "searchRepoCell"
    
    var searchBar: UISearchBar!
    
    var repos = [Repositiory]()
    var currentPage = 1
    var totalCount = 10
    var keyword: String = ""
    
    override func viewDidLoad() {
        
        tableView.registerNib(UINib(nibName: "SearchRepoCell", bundle: nil), forCellReuseIdentifier: REPO_CELL)
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(fetchData))
        tableView.mj_footer = footer

        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width-20, self.view.frame.height))
        searchBar.placeholder = "Search"
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        searchBar.becomeFirstResponder()
    }

}

extension SearchViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let repo = repos[indexPath.row]
        let repoCell = tableView.dequeueReusableCellWithIdentifier(REPO_CELL, forIndexPath: indexPath) as! SearchRepoCell
        
        let attributeString = NSMutableAttributedString(string: "\(repo.owner.login)/")
        let attrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(16)]
        attributeString.appendAttributedString(NSAttributedString(string: repo.name, attributes: attrs))
        repoCell.repoName.attributedText = attributeString
        
        if let desc = repo.description {
            repoCell.desc.text = "\(desc)"
        }
        
        if let language = repo.language {
            repoCell.lang.text = "\(language)"
        }
        
        
        repoCell.stars.text = "\(repo.stars)"
        repoCell.avatar.kf_setImageWithURL(NSURL(string: "\(repo.owner.avatarUrl)")!, placeholderImage: UIImage(named: "ic_all.png"))
        
        return repoCell
    }
    
    func fetchData() {
        print("current page: \(currentPage), total: \(totalCount)" )
        if currentPage * 10 > totalCount {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        GitHubAPI.searchRepos(self.keyword, page: "\(currentPage)") { items in
            self.tableView.mj_footer.endRefreshing()
            if self.currentPage == 1 {
                self.repos.removeAll()
                self.repos = items.items
            } else {
                self.repos += items.items
            }
            self.currentPage += 1
            self.totalCount = items.count
            self.tableView.reloadData()
        }
    }
}



extension SearchViewController: UISearchBarDelegate {
    // MARK: SearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let key = searchBar.text else {
            return
        }
        searchBar.endEditing(true)
        currentPage = 0
        keyword = key
        fetchData()
    }

}
