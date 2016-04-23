//
//  DevTableViewCell.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/4/2.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit

class DevTableViewCell: UITableViewCell {

    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var repoName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindItem(item: Developer) {
        avatar.layer.cornerRadius = 5
        avatar.layer.masksToBounds = true
        let attributeString = NSMutableAttributedString(string: "\(item.loginName)")
        let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(16), NSForegroundColorAttributeName: UIColor.blackColor()]
        attributeString.appendAttributedString(NSAttributedString(string: item.fullName, attributes: attrs))
        name.attributedText = attributeString
        
        rank.text = "\(item.rank)"
        repoName.text = "\(item.repoName)  \(item.repoDesc)"
        avatar.kf_setImageWithURL(NSURL(string: item.avatar)!)
    }

}
