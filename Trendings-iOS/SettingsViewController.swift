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

class SettingsViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        
        switch section {
        case 0:
            shareClicked()
        case 1:
            reviewClick()
        case 2:
            aboutClicked()
        default:
            break
        }
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
