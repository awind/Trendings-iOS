//
//  SearchUserCell.swift
//  Trending
//
//  Created by SongFei on 16/4/23.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {
    
    @IBOutlet weak var loginName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindItem(user: User) {
        loginName.text = "\(user.login)"
        avatar.layer.cornerRadius = 5
        avatar.layer.masksToBounds = true
        avatar.kf_setImageWithURL(NSURL(string: "\(user.avatar)")!, placeholderImage: UIImage(named: "ic_all.png"))
    }
    
}
