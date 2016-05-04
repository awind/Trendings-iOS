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

class SearchViewController: UIViewController, UISearchBarDelegate, CAPSPageMenuDelegate {
    
    var pageMenu: CAPSPageMenu?
    var searchBar: UISearchBar!
    
    var repoVC = RepoSearchViewController()
    var userVC = UserSearchViewController()
    var controllerArray : [UIViewController] = []
    
    var keyword = ""
    var currentPageIndex = 0
    
    override func viewDidLoad() {
        
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
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 60.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.useMenuLikeSegmentedControl = true
        pageMenu?.delegate = self
        
        self.view.addSubview(pageMenu!.view)
    }
    
    
    func initSearchBar() {
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width - 20, self.view.frame.height))
        searchBar.placeholder = "Search users or repositiories"
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }
    
    func didMoveToPage(controller: UIViewController, index: Int) {
        self.currentPageIndex = index
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
