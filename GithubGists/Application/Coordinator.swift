//
//  Coordinator.swift
//  GithubGists
//
//  Created by Константин Туголуков on 26.06.2022.
//

import UIKit

protocol CoordinatorProtocol {
    func start()
}

final class Coordinator {
    
    private let navigationController: UINavigationController
    private let factory: FactoryProtocol
    
    init(navigationController: UINavigationController, factory: FactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
}

//MARK: - CoordinatorProtocol
extension Coordinator: CoordinatorProtocol {
    
    func start() {
        let gistListViewController = factory.makeGistListViewController()
        gistListViewController.delegate = self
        navigationController.viewControllers = [gistListViewController]
    }
    
    func showDetails(model: Gist) {
        let gistListViewController = factory.makeGistDetailsViewController(model: model)
        navigationController.pushViewController(gistListViewController, animated: true)
    }
    
}

//MARK: - GistsListViewControllerDelegate
extension Coordinator: GistsListViewControllerDelegate {
    
    func presentDetails(model: Gist) {
        showDetails(model: model)
    }

}
