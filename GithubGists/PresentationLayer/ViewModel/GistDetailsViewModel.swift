//
//  GistDetailsViewModel.swift
//  GithubGists
//
//  Created by Константин Туголуков on 25.06.2022.
//

import Foundation

class GistDetailsViewModel {
    
    private let client: GitHubClientProtocol
    
    var gist: Gist
    var files: Dynamic<[File]> = Dynamic([])
    var commits: Dynamic<[Commit]> = Dynamic([])
    var errors: Dynamic<String> = Dynamic("")
    
    init(client: GitHubClientProtocol, gist: Gist) {
        self.client = client
        self.gist = gist
        updateData()
    }
    
    func updateData() {
        files.value = getFiles(gist: gist)
        fetchCommits(id: gist.id)
    }
    
    private func getFiles(gist: Gist) -> [File] {
        return gist.files?.values.map { $0 } ?? []
    }
    
    private func fetchCommits(id: String) {
        client.getCommitsByGist(id: id) { [weak self] result in
            switch result {
                case .failure(let error):
                    if let error = error.errorDescription {
                        self?.errors.value = error
                    }
                case .success(let commits):
                    if let commits = commits {
                        self?.commits.value = commits
                    }
            }
        }
    }

}
