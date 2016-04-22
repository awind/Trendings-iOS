//
//  SearchViewController.swift
//  Trending
//
//  Created by SongFei on 16/4/22.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    let REPO_CELL = "searchRepoCell"
    
    var searchBar: UISearchBar!
    
    var repos = [Repositiory]()
    
    override func viewDidLoad() {
        
        tableView.registerNib(UINib(nibName: "SearchRepoCell", bundle: nil), forCellReuseIdentifier: REPO_CELL)
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension

        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width-20, self.view.frame.height))
        searchBar.placeholder = "Search"
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        self.navigationItem.leftBarButtonItem = leftNavBarButton
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
        
        repoCell.desc.text = "\(repo.description)"
        if repo.language != nil {
            repoCell.lang.text = "\(repo.language!)"
        } else {
            repoCell.lang.text = "Unknown"
        }
        repoCell.stars.text = "\(repo.stars)"
        repoCell.avatar.kf_setImageWithURL(NSURL(string: "\(repo.owner.avatarUrl)")!, placeholderImage: UIImage(named: "ic_all.png"))
        
        return repoCell
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
        GitHubAPI.searchRepos(key) { items in
            self.repos = items.items
            self.tableView.reloadData()
        }
    }

}
