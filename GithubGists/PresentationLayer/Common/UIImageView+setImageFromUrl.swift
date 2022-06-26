//
//  UIImageView+setImageFromUrl.swift
//  GithubGists
//
//  Created by Константин Туголуков on 23.06.2022.
//

import UIKit

extension UIImageView {
    
    func setImageFromUrl(urlString: String, cache: URLCache? = nil) {
        guard let url = URL(string: urlString) else { return }
        
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard error == nil else { return }
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode == 200), let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                    }
                }
            }).resume()
        }
    }
    
}
