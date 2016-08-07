//
//  TopUserTableViewCell.swift
//  Trending
//
//  Created by Song, Phillip on 8/7/16.
//  Copyright © 2016 SongFei. All rights reserved.
//

import UIKit

class TopUserTableViewCell: UITableViewCell {

    @IBOutlet weak var rankNum: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindItem(user: User, indexPath: NSIndexPath) {
        username.text = "\(user.login)"
        avatar.layer.cornerRadius = 5
        avatar.layer.masksToBounds = true
        avatar.kf_setImageWithURL(NSURL(string: "\(user.avatar)")!, placeholderImage: UIImage(named: "ic_all.png"))
        rankNum.text = "#\(indexPath.row + 1)"
    }
}
