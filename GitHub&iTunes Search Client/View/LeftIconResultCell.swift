//
//  LeftIconResultCell.swift
//  GitHub&iTunes Search Client
//
//  Created by Sasha Evtushenko on 6/30/20.
//  Copyright © 2020 Sasha Evtushenko. All rights reserved.
//

import UIKit

class LeftIconResultCell: UITableViewCell {

    @IBOutlet var rightBottomLabel: UILabel!
    @IBOutlet var rightTopLabel: UILabel!
    @IBOutlet var icon: UIImageView!

    func configureCell(iTunesItem: iTunesItem) {
        self.rightTopLabel.text = iTunesItem.artistName
        self.rightBottomLabel.text = iTunesItem.trackName
        self.icon.sd_setImage(with: URL(string: iTunesItem.artworkUrl60), completed: nil)
    }
    
    func configureCell(gitHubUser: GitHubUser) {
        self.rightTopLabel.text = gitHubUser.login
        self.rightBottomLabel.text = gitHubUser.html_url
        self.icon.sd_setImage(with: URL(string: gitHubUser.avatar_url), completed: nil)
    }
}
