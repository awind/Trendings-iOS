//
//  SegmentedTableViewCell.swift
//  Trendings-iOS
//
//  Created by SongFei on 16/4/5.
//  Copyright © 2016年 SongFei. All rights reserved.
//

import UIKit

class SegmentedTableViewCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
