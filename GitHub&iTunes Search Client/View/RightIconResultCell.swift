//
//  iTunesRightIconResultCell.swift
//  GitHub&iTunes Search Client
//
//  Created by Sasha Evtushenko on 6/30/20.
//  Copyright © 2020 Sasha Evtushenko. All rights reserved.
//

import UIKit
import SDWebImage

class RightIconResultCell: UITableViewCell {

    @IBOutlet var leftBottomLabel: UILabel!
    @IBOutlet var leftTopLabel: UILabel!
    @IBOutlet var icon: UIImageView!

    func configureCell(iTunesItem: iTunesItem) {
        self.leftTopLabel.text = iTunesItem.artistName
        self.leftBottomLabel.text = iTunesItem.trackName
        self.icon.sd_setImage(with: URL(string: iTunesItem.artworkUrl60), completed: nil)
    }
    
    func configureCell(gitHubUser: GitHubUser) {
        self.leftTopLabel.text = gitHubUser.login
        self.leftBottomLabel.text = gitHubUser.html_url
        self.icon.sd_setImage(with: URL(string: gitHubUser.avatar_url), completed: nil)
    }
}
