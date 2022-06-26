//
//  GitHubResource.swift
//  GithubGists
//
//  Created by Константин Туголуков on 22.06.2022.
//

import Foundation

typealias HTTPHeaders = Dictionary<String, String>

struct NetworkResource<Value> where Value: Decodable {
    
    var path: String
    var method: HTTPMethod
    var headers: HTTPHeaders?
    
    init(path: String, method: HTTPMethod = .get, headers: HTTPHeaders? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
    }
    
}
