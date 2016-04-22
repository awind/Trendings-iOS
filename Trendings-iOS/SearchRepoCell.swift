//
//  SearchRepoCell.swift
//  Trending
//
//  Created by SongFei on 16/4/22.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit

class SearchRepoCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var lang: UILabel!
    @IBOutlet weak var stars: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
