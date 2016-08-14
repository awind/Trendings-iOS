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
            reviewClick()
        case 1:
            aboutClicked()
        default:
            break
        }
    }
    
    func aboutClicked() {
        let svc = SFSafariViewController(URL: NSURL(string: "https://github.com/awind")!)
        self.presentViewController(svc, animated: true, completion: nil)
        FabricEvent.logCustomEvent(TrendingString.EVENT_ABOUT_AUTHOR)
    }
    
    func reviewClick() {
        Armchair.rateApp()
        FabricEvent.logCustomEvent(TrendingString.EVENT_REVIEW)
    }
}
