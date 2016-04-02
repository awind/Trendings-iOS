//
//  ViewController.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/3/27.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

    let CELL = "repoCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var repos = [Repo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        getTrendings()
    }
    
    func getTrendings() {
        TrendingAPI.getTrendings("all", since: "daily") { items in
            self.repos = items.items
            self.tableView.reloadData()
        }
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
        let repo = repos[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL, forIndexPath: indexPath) as! RepoTableViewCell
        
        cell.title.text = "\(repo.owner)\(repo.name)"
        cell.desc.text = "\(repo.description)"
        cell.star.text = "\(repo.star)"
        return cell
    }
    
    
}

