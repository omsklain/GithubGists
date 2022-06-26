//
//  GitHubResource.swift
//  GithubGists
//
//  Created by Константин Туголуков on 22.06.2022.
//

import Foundation

enum GitHubResource {
    
    case publicGists(page: Int, counts: Int)
    case gist(id: String)
    case gistsByUser(user: String)
    
    func resource<T>() -> NetworkResource<T> where T: Decodable{
        switch self {
            case let .publicGists(page, counts):
                return NetworkResource(path: "/gists/public?page=\(page)&per_page=\(counts)", method: .get)
            case let .gist(id):
                return NetworkResource(path: "/gists/\(id)/commits", method: .get)
            case let .gistsByUser(user):
                return NetworkResource(path: "/users/\(user)/gists", method: .get)
        }
    }

}
