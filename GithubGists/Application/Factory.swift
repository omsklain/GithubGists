//
//  Factory.swift
//  GithubGists
//
//  Created by Константин Туголуков on 27.06.2022.
//

import UIKit

protocol FactoryProtocol {
    func makeGistListViewController() -> GistsListViewController
    func makeGistDetailsViewController(model: Gist) -> GistDetailsViewController
}

final class Factory {
    
    private let client: GitHubClientProtocol
    
    init(client: GitHubClientProtocol) {
        self.client = client
    }
    
}

//MARK: - FactoryProtocol
extension Factory: FactoryProtocol {
    
    func makeGistListViewController() -> GistsListViewController {
        let viewModel = ListViewModel(client: self.client)
        let viewController = GistsListViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeGistDetailsViewController(model: Gist) -> GistDetailsViewController {
        let viewController: GistDetailsViewController = UIStoryboard(name: "GistDetails", bundle: nil).instantiateViewController(identifier: "GistDetailsViewController") { coder in
            let viewModel = GistDetailsViewModel(client: self.client, gist: model)
            return GistDetailsViewController(coder: coder, viewModel: viewModel)
        }
        return viewController
    }
    
}
