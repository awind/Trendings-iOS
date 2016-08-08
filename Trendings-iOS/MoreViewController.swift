//
//  SettingsViewController.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/4/4.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import SafariServices
import Armchair

class MoreViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TrendingString.TITLE_MORE
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        
        switch section {
        case 0:
            topRepoClicked()
        case 1:
            topDevClicked()
        case 2:
            shareClicked()
        case 3:
            reviewClick()
        case 4:
            aboutClicked()
        default:
            break
        }
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
    
    func shareClicked() {
        let urlToShare = "http://bit.ly/1Yl4P3k"
        let array = ["This app is awesome! Click \(urlToShare) to download!"]
        let activityVC = UIActivityViewController(activityItems: array, applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
   func aboutClicked() {
        let svc = SFSafariViewController(URL: NSURL(string: "https://github.com/awind")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    func reviewClick() {
        Armchair.rateApp()
    }
}
