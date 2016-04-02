//
//  ViewController.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/3/27.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import SafariServices

class RepoViewController: UIViewController {

    let CELL = "repoCell"
    
    var language = "all"
    var currentIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    var repos = [Repo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repositiories"
        tableView.estimatedRowHeight = 138.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        getTrendings(language, since: "daily")
    }
    
    func getTrendings(language: String, since: String) {
        TrendingAPI.getTrendings(language, since: since) { items in
            self.repos = items.items
            self.tableView.reloadData()
        }
    }

    @IBAction func segmentIndexChange(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == currentIndex  {
            return
        }
        currentIndex = index
        switch index {
        case 0:
            getTrendings(language, since: "daily")
        case 1:
            getTrendings(language, since: "weekly")
        case 2:
            getTrendings(language, since: "monthly")
        default:
            break
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repo = repos[indexPath.row]
        let svc = SFSafariViewController(URL: NSURL(string: "https://github.com\(repo.url)")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
}

