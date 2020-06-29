//
//  GitHubUser.swift
//  GitHub&iTunes Search Client
//
//  Created by Sasha Evtushenko on 6/29/20.
//  Copyright © 2020 Sasha Evtushenko. All rights reserved.
//

import Foundation

struct GitHubUsers: Decodable {
    var items: [GitHubUser]
}

struct GitHubUser: Decodable {
    var avatar_url: String
    var login: String
    var html_url: String
}
