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

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func shareClicked(sender: UIButton) {
        let urlToShare = ""
        let array = ["This app is awesome! Click to \(urlToShare) download!"]
        let activityVC = UIActivityViewController(activityItems: array, applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func aboutClicked(sender: UIButton) {
        let svc = SFSafariViewController(URL: NSURL(string: "https://github.com/awind")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    @IBAction func reviewClick(sender: UIButton) {
        Armchair.rateApp()
    }
    
    
    
    
}
