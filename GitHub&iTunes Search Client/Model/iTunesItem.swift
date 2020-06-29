//
//  iTunesItem.swift
//  GitHub&iTunes Search Client
//
//  Created by Sasha Evtushenko on 6/29/20.
//  Copyright © 2020 Sasha Evtushenko. All rights reserved.
//

import Foundation

struct iTunesItems: Decodable {
    var results: [iTunesItem]
}

struct iTunesItem: Decodable {
    var artistName: String
    var trackName: String
    var artworkUrl60: String
}
