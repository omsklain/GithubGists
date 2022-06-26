//
//  Router.swift
//  GithubGists
//
//  Created by Константин Туголуков on 26.06.2022.
//

import UIKit

protocol RouterProtocol {
    func start()
}

final class Router {
    
    private let navigationController: UINavigationController
    private let client: GitHubClientProtocol
    
    init(navigationController: UINavigationController, client: GitHubClientProtocol) {
        self.navigationController = navigationController
        self.client = client
    }
    
}

//MARK: - RouterProtocol
extension Router: RouterProtocol {
    
    func start() {
        let gistListViewController = makeGistListViewController()
        navigationController.viewControllers = [gistListViewController]
    }
    
}

//MARK: - Building views controller
extension Router {
    
    private func makeGistListViewController() -> GistsListViewController {
        let viewModel = ListViewModel(client: self.client)
        let viewController = GistsListViewController(viewModel: viewModel)
        viewController.delegate = self
        return viewController
    }
    
}

//MARK: - GistsListViewControllerDelegate
extension Router: GistsListViewControllerDelegate {
    
    func presentDetails(model: Gist) {
        let viewController = UIStoryboard(name: "GistDetails", bundle: nil).instantiateViewController(identifier: "GistDetailsViewController") { coder in
            let viewModel = GistDetailsViewModel(client: self.client, gist: model)
            return GistDetailsViewController(coder: coder, viewModel: viewModel)
        }
        self.navigationController.pushViewController(viewController, animated: true)
    }

}
