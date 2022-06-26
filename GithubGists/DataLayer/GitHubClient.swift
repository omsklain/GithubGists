//
//  GitHubClient.swift
//  GithubGists
//
//  Created by Константин Туголуков on 22.06.2022.
//

import Foundation

protocol GitHubClientProtocol {
    func getPublicGists( page: Int, counts: Int ,completion: @escaping (Result<[Gist]?, NetworkError>) -> Void )
    func getCommitsByGist( id: String, completion: @escaping (Result<[Commit]?, NetworkError>) -> Void )
}

final class GitHubClient: NetworkService {
    
    typealias resource = GitHubResource
    
    private(set) lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.timeoutIntervalForRequest = 30.0
        config.urlCache = .none
        return URLSession(configuration: config, delegate: .none, delegateQueue: .none)
    }()
    
    private var baseURLString: String {
        "https://api.github.com"
    }
    
    private var globalHeaders: HTTPHeaders? {
        ["application/vnd.github.v3+json" : "Accept"]
    }
    
    private func fetch<T> (resource: NetworkResource<T>, completion: @escaping (T?, NetworkError?) -> Void ) where T: Decodable {
        guard let url = URL(string: baseURLString + resource.path) else {
            return completion(nil, .invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = resource.method.rawValue
        globalHeaders?.forEach{ request.addValue($0, forHTTPHeaderField: $1) }
        
        fetch(request: request) { data, networkError in
            if let networkError = networkError {
                completion(nil, networkError)
            }
            if let data = data {
                do {
                    let decodeData = try JSONDecoder().decode(T.self, from: data)
                    return completion(decodeData, nil)
                } catch {
                    return completion(nil, .JSONDecoderError(error))
                }
            }
        }
    }
}

// MARK: - GitHubClientProtocol
extension GitHubClient: GitHubClientProtocol {
    
    func getPublicGists( page: Int, counts: Int ,completion: @escaping (Result<[Gist]?, NetworkError>) -> Void ) {
        let resource: NetworkResource<[Gist]> = resource.publicGists(page: page, counts: counts).resource()
        self.fetch(resource: resource) { gists, networkError in
            if let networkError = networkError {
                DispatchQueue.main.async { completion(.failure(networkError)) }
            }
            if let gists = gists {
                DispatchQueue.main.async { completion(.success(gists)) }
            }
        }
    }
    
    func getCommitsByGist( id: String, completion: @escaping (Result<[Commit]?, NetworkError>) -> Void ) {
        let resource: NetworkResource<[Commit]> = resource.gist(id: id).resource()
        self.fetch(resource: resource) { commits, networkError in
            if let networkError = networkError {
                DispatchQueue.main.async { completion(.failure(networkError)) }
            }
            if let commits = commits {
                DispatchQueue.main.async { completion(.success(commits)) }
            }
        }
    }
    
}
