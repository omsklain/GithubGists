//
//  NetworkError.swift
//  GithubGists
//
//  Created by Константин Туголуков on 22.06.2022.
//

import Foundation

enum NetworkError: Error {
    
    case invalidURL
    case URLRequestError(Error)
    case JSONDecoderError(Error)
    case HTTPURLResponseError(statusCode: Int, description: String)
    
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .URLRequestError(let error):
            return NSLocalizedString(error.localizedDescription, comment: "URLRequestError")
        case .JSONDecoderError(let error):
            return NSLocalizedString(error.localizedDescription, comment: "JSONDecoderError")
        case .HTTPURLResponseError(let code , let description):
            return NSLocalizedString("Code: \(code) - \(description)", comment: "HTTPURLResponse")
        }
    }
    
}
