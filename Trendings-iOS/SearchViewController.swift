//
//  SearchViewController.swift
//  Trending
//
//  Created by SongFei on 16/4/22.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import SafariServices
import MJRefresh
import MBProgressHUD

class SearchViewController: UITableViewController {
    
    let DEFAULT_CELL = "cell"
    let REPO_CELL = "searchRepoCell"
    let USER_CELL = "searchUserCell"
    
    var searchBar: UISearchBar!
    
    var repos = [Repositiory]()
    var users = [User]()
    var searchRecommands = ["View top reposities", "View top developers"]
    var currentPage = 1
    var totalCount = 10
    var keyword: String = ""
    var isSearchRepo = true
    
    var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        
        tableView.registerNib(UINib(nibName: "SearchRepoCell", bundle: nil), forCellReuseIdentifier: REPO_CELL)
        tableView.registerNib(UINib(nibName: "SearchUserCell", bundle: nil), forCellReuseIdentifier: USER_CELL)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: DEFAULT_CELL)
        
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(fetchData))
        footer.setTitle("Pull to refresh", forState: .Idle)
        footer.setTitle("Release to refresh", forState: .Pulling)
        footer.setTitle("Loading", forState: .Refreshing)
        tableView.mj_footer = footer

        initSearchBar()
    }
    
    func initSearchBar() {
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width-20, self.view.frame.height))
        if isSearchRepo {
            searchBar.placeholder = "Search Repositiories"
        } else {
            searchBar.placeholder = "Search Users"
        }
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
        if isSearchRepo {
            if self.repos.count == 0 {
                return searchRecommands.count
            }
            return repos.count
        } else {
            if self.users.count == 0 {
                return searchRecommands.count
            }
            return users.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if isSearchRepo {
            
            if repos.count == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(DEFAULT_CELL, forIndexPath: indexPath)
                cell.textLabel?.text = searchRecommands[indexPath.row]
                cell.textLabel?.textColor = UIColor(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1)
                cell.imageView?.image = UIImage(named: "ic_about")
                return cell
            }
            
            let repo = repos[indexPath.row]
            let repoCell = tableView.dequeueReusableCellWithIdentifier(REPO_CELL, forIndexPath: indexPath) as! SearchRepoCell
            repoCell.bindItem(repo)
            return repoCell
        } else {
            if users.count == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(DEFAULT_CELL, forIndexPath: indexPath)
                cell.textLabel?.text = searchRecommands[indexPath.row]
                cell.imageView?.image = UIImage(named: "ic_about")
                return cell
            }

            let user = users[indexPath.row]
            let userCell = tableView.dequeueReusableCellWithIdentifier(USER_CELL, forIndexPath: indexPath) as! SearchUserCell
            userCell.bindItem(user)
            return userCell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var svc: SFSafariViewController
        if isSearchRepo {
            if repos.count == 0 {
                let vc = TopViewController()
                switch indexPath.row {
                case 0:
                    vc.isTopRepo = true
                case 1:
                    vc.isTopRepo = false
                default:
                    break
                }
                let navVc = UINavigationController(rootViewController: vc)
                self.presentViewController(navVc, animated: true, completion: nil)
            } else {
                let repo = repos[indexPath.row]
                svc = SFSafariViewController(URL: NSURL(string: repo.url)!)
                self.presentViewController(svc, animated: true, completion: nil)
            }
        } else {
            if users.count == 0 {
                print("didSelectRowAtIndexPath")
            } else {
                let user = users[indexPath.row]
                svc = SFSafariViewController(URL: NSURL(string: user.url)!)
                self.presentViewController(svc, animated: true, completion: nil)
            }
        }
        
    }

    
    func fetchData() {
        if self.keyword.isEmpty {
            tableView.mj_footer.endRefreshing()
            return
        }
        
        if currentPage * 10 > totalCount {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        
        if isSearchRepo {
            searchRepos()
        } else {
            searchUsers()
        }
        
    }
    
    func searchRepos() {
        GitHubAPI.searchRepos(self.keyword, page: "\(currentPage)", completion: { items in
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
            self.hud.hide(true)
            }, fail:  { error in
                self.tableView.mj_footer.endRefreshing()
                self.hud.labelText = "Loading Error"
                self.hud.hide(true, afterDelay: 1)
        })
    }
    
    func searchUsers() {
        GitHubAPI.searchUsers(self.keyword, page: "\(currentPage)", completion: { items in
            self.tableView.mj_footer.endRefreshing()
            if self.currentPage == 1 {
                self.users.removeAll()
                self.users = items.items
            } else {
                self.users += items.items
            }
            self.currentPage += 1
            self.totalCount = items.count
            self.tableView.reloadData()
            self.hud.hide(true)
            }, fail: { error in
                self.tableView.mj_footer.endRefreshing()
                self.hud.labelText = "Loading Error"
                self.hud.hide(true, afterDelay: 1)
                
        })
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
        currentPage = 1
        totalCount = 11
        keyword = key
        hud = MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        hud.mode = .Indeterminate
        hud.labelText = "Loading"
        hud.removeFromSuperViewOnHide = true
        
        fetchData()
    }

}
