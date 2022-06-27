//
//  NetworkService.swift
//  GithubGists
//
//  Created by Константин Туголуков on 22.06.2022.
//

import Foundation

protocol NetworkService: AnyObject {
    var session: URLSession { get }

    func fetch (request: URLRequest, completion: @escaping (Data?, NetworkError?) -> Void )
}

// MARK: - Default method
extension NetworkService {
    
    func fetch (request: URLRequest, completion: @escaping (Data?, NetworkError?) -> Void ) {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(nil, .URLRequestError(error))
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                let discriptionCode = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                return completion(nil, .HTTPURLResponseError(statusCode: response.statusCode, description: discriptionCode))
            }
            if let data = data {
                return completion(data, nil)
            }
        }
        task.resume()
    }

}
