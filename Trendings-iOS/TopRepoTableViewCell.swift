//
//  TopRepoTableViewCell.swift
//  Trending
//
//  Created by Song, Phillip on 8/7/16.
//  Copyright © 2016 SongFei. All rights reserved.
//

import UIKit

class TopRepoTableViewCell: UITableViewCell {

    @IBOutlet weak var rankNum: UILabel!
    
    
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var lang: UILabel!
    @IBOutlet weak var repoDesc: UILabel!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindItem(repo: Repositiory, indexPath: NSIndexPath) {
        avatar.layer.cornerRadius = 5
        avatar.layer.masksToBounds = true
        
        let attributeString = NSMutableAttributedString(string: "\(repo.owner.login)/")
        let attrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(16)]
        attributeString.appendAttributedString(NSAttributedString(string: repo.name, attributes: attrs))
        repoName.attributedText = attributeString
        
        if let description = repo.description {
            repoDesc.text = "\(description)"
        }
        
        if let language = repo.language {
            lang.text = "\(language)"
        }
        
        star.text = "\(repo.stars)"
        avatar.kf_setImageWithURL(NSURL(string: "\(repo.owner.avatarUrl)")!, placeholderImage: UIImage(named: "ic_all.png"))
        
        rankNum.text = "#\(indexPath.row + 1)"
    }

    
}
