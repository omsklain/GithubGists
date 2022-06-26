//
//  UITextView+loadFromUrl.swift
//  GithubGists
//
//  Created by Константин Туголуков on 26.06.2022.
//

import Foundation
import UIKit

extension UITextView {
    
    func loadFromUrl(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil else { return }
            if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode == 200) {
                if let text = String(data: data, encoding: String.Encoding.utf8) {
                    DispatchQueue.main.async { [weak self] in
                        self?.text = text
                    }
                }
            }
        }).resume()
    }
    
}
