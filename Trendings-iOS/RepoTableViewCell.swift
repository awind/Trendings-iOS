//
//  RepoTableViewCell.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/4/2.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit
import Kingfisher

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var lang: UIImageView!
    @IBOutlet weak var avaterContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addContributor(contributors: [Contributor]) {
        for view in avaterContainer.subviews {
            view.removeFromSuperview()
        }
        
        var curFrame = CGRectMake(0, 0, 24, 24)
        for item in contributors {
            let imageView = UIImageView(frame: curFrame)
            imageView.kf_setImageWithURL(NSURL(string: item.avatar)!)
            avaterContainer.addSubview(imageView)
            curFrame.origin.x += 26;
        }

    }

}
