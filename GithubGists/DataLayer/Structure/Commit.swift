//
//  Commit.swift
//  GithubGists
//
//  Created by Константин Туголуков on 25.06.2022.
//

import Foundation

struct Commit: Decodable {
    
    let login: String
    let avatarUrl: String
    let additions: Int
    let deletions: Int
    
    enum CodingKeys: String, CodingKey {
        case user
        case status = "change_status"
    }
    
    enum AdditionalInfoKeys: String, CodingKey {
        case login, additions, deletions
        case avatarUrl = "avatar_url"
    }
    
}

extension Commit {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
 
        let user = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .user)
        login = try user.decode(String.self, forKey: .login)
        avatarUrl = try user.decode(String.self, forKey: .avatarUrl)
        
        let status = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .status)
        additions = try status.decode(Int.self, forKey: .additions)
        deletions = try status.decode(Int.self, forKey: .deletions)
    }
    
}
