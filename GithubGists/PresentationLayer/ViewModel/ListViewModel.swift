//
//  ListViewModel.swift
//  GithubGists
//
//  Created by Константин Туголуков on 23.06.2022.
//

import Foundation

class ListViewModel {
    
    private let client: GitHubClientProtocol
    
    var items: Dynamic<[Gist]> = Dynamic([])
    var errors: Dynamic<String> = Dynamic("")
    
    private var page = 1
    private var isNextFetching = false
    
    init(client: GitHubClientProtocol) {
        self.client = client
        fetch(page: page)
    }
    
    private func fetch(page: Int) {
        client.getPublicGists(page: page, counts: 30) { [weak self] result in
            switch result {
                case .failure(let error):
                    if let error = error.errorDescription {
                        self?.errors.value = error
                    }
                case .success(let data):
                    if let data = data {
                        if page == 1 {
                            self?.items.value = data
                        } else {
                            self?.items.value.append(contentsOf: data)
                        }
                    }
            }
            self?.isNextFetching = false
        }
    }
    
    func fetchReload() {
        page = 1
        fetch(page: page)
    }
    
    func nextFetch() {
        guard !isNextFetching else { return }
        isNextFetching = true
        page += 1
        fetch(page: page)
    }
    
}
