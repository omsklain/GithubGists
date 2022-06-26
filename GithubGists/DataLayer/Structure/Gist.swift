//
//  Gist.swift
//  GithubGists
//
//  Created by Константин Туголуков on 24.06.2022.
//

import Foundation

struct Gist: Decodable {
    
    let id: String
    let login: String
    let avatarUrl: String
    let firstFileName: String?
    let files: [String:File]?
    
    enum CodingKeys: String, CodingKey {
        case id, owner, files
    }
    
    enum AdditionalInfoKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
    
}

extension Gist {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
 
        id = try values.decode(String.self, forKey: .id)
        
        let owner = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .owner)
        login = try owner.decode(String.self, forKey: .login)
        avatarUrl = try owner.decode(String.self, forKey: .avatarUrl)
        
        files = try values.decode([String:File]?.self, forKey: .files)
        let files:[String:File]?  = try values.decode([String:File]?.self, forKey: .files)
        firstFileName = files?.first?.key
    }
    
}
