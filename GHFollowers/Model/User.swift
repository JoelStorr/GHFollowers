//
//  User.swift
//  GHFollowers
//
//  Created by Joel Storr on 16.08.23.
//

import Foundation


struct User: Codable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicrepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
}
