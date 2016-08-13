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

class SearchViewController: UIViewController, UISearchBarDelegate, CAPSPageMenuDelegate {
    
    var pageMenu: CAPSPageMenu?
    var searchBar: UISearchBar!
    
    var repoVC = RepoSearchViewController()
    var userVC = UserSearchViewController()
    var controllerArray : [UIViewController] = []
    
    var keyword = ""
    var currentPageIndex = 0
    
    override func viewDidLoad() {
//        self.title = TrendingString.TITLE_SEARCH
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 142.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        initSearchBar()
        initPageMenu()
    }
    
    func initPageMenu() {
        
        repoVC.title = "Repos"
        repoVC.parentNavigationController = self.navigationController
        userVC.title = "Users"
        userVC.parentNavigationController = self.navigationController
        controllerArray.append(repoVC)
        controllerArray.append(userVC)
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)),
            .BottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
            .SelectionIndicatorColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
            .MenuHeight(40.0),
            .SelectedMenuItemLabelColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
            .UnselectedMenuItemLabelColor(UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorRoundEdges(true),
            .SelectionIndicatorHeight(2.0),
            .MenuItemSeparatorPercentageHeight(0.1)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64.0, self.view.frame.width, self.view.frame.height - 113), pageMenuOptions: parameters)
        pageMenu?.useMenuLikeSegmentedControl = true
        pageMenu?.delegate = self
        
        self.view.addSubview(pageMenu!.view)
    }
    
    
    func initSearchBar() {
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "ic_bookmark.png"), style: .Plain, target: self, action: #selector(bookmarkClicked))
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width - 60, self.view.frame.height))
        searchBar.placeholder = "Search Repositiories"
        let rightNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        searchBar.showsCancelButton = true
        searchBar.delegate = self
    }
    
    func didMoveToPage(controller: UIViewController, index: Int) {
        self.currentPageIndex = index
        if self.currentPageIndex == 0 {
            self.searchBar.placeholder = "Search Repositiories"
        } else {
            self.searchBar.placeholder = "Search Users"
        }
    }
    
    func bookmarkClicked() {
        let topRankController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let topRankRepoAction = UIAlertAction(title: "Top Repositiory", style: .Default) { action in
            self.topRepoClicked()
        }
        let topRankDevAction = UIAlertAction(title: "Top Developer", style: .Default) { action in
            self.topDevClicked()
        }
        topRankController.addAction(topRankRepoAction)
        topRankController.addAction(topRankDevAction)
        topRankController.addAction(cancelAction)
        self.presentViewController(topRankController, animated: true, completion: nil)
    }
    
    func topRepoClicked() {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(TopRepoViewController(), animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    func topDevClicked() {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(TopDevViewController(), animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    
    // MARK: SearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.keyword = searchText
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if self.currentPageIndex == 0 {
            self.repoVC.keyword = self.keyword
        } else {
            self.userVC.keyword = self.keyword
        }
        searchBar.endEditing(true)
    }

}
