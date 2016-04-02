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
//    @IBOutlet weak var avatarContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    
//    func addContributor(contributor: Contributor) {
//        let avatar = UIImageView(frame: CGRectMake(0, 0, avatarContainer.frame.height, avatarContainer.frame.height))
//        avatar.kf_setImageWithURL(NSURL(string: contributor.avatar)!)
//        avatarContainer.addSubview(avatar)
//    }

}
