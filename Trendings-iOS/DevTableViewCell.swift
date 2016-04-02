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
    
    @IBOutlet weak var repoDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
