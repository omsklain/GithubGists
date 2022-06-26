//
//  File.swift
//  GithubGists
//
//  Created by Константин Туголуков on 25.06.2022.
//

import Foundation

struct File: Decodable {
    
    let filename: String?
    let rawURL: String?

    enum CodingKeys: String, CodingKey {
        case filename
        case rawURL = "raw_url"
    }
    
}
