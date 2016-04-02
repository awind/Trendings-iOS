//
//  RepoTableViewCell.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/4/2.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var avatar: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
