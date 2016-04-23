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
    
    func bindItem(repo: Repositiory) {
        avatar.layer.cornerRadius = 5
        avatar.layer.masksToBounds = true
        
        let attributeString = NSMutableAttributedString(string: "\(repo.owner.login)/")
        let attrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(16)]
        attributeString.appendAttributedString(NSAttributedString(string: repo.name, attributes: attrs))
        repoName.attributedText = attributeString
        
        if let description = repo.description {
            desc.text = "\(description)"
        }
        
        if let language = repo.language {
            lang.text = "\(language)"
        }
        
        stars.text = "\(repo.stars)"
        avatar.kf_setImageWithURL(NSURL(string: "\(repo.owner.avatarUrl)")!, placeholderImage: UIImage(named: "ic_all.png"))
    }
    
}
