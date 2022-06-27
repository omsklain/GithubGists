//
//  GistsListViewController.swift
//  GithubGists
//
//  Created by Константин Туголуков on 22.06.2022.
//

import UIKit

protocol GistsListViewControllerDelegate: AnyObject {
    func presentDetails(model: Gist)
}

class GistsListViewController: UIViewController {

    let viewModel: ListViewModel
    weak var delegate: GistsListViewControllerDelegate?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = .init(top: 0, left: 70, bottom: 0, right: 0)
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gists list"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupDynamicValues()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupDynamicValues() {
        viewModel.items.bind { [weak self] items in
            self?.endRefrreshing()
            if let lastCountItems = self?.tableView.numberOfRows(inSection: 0) {
                if items.count > lastCountItems {
                    let indexPaths = (lastCountItems..<items.count).map { IndexPath(item: $0, section: 0) }
                    self?.tableView.performBatchUpdates({
                        self?.tableView.insertRows(at: indexPaths, with: .none)
                    })
                } else {
                    self?.tableView.reloadData()
                }
            }
        }
        
        viewModel.errors.bind { [weak self] error in
            let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: .default))
            self?.present(alert, animated: true, completion: { self?.refreshControl.endRefreshing() })
        }
        
    }
    
    private func endRefrreshing() {
        if self.refreshControl.isRefreshing {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func refresh() {
        viewModel.fetchReload()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height >= view.frame.size.height else { return }
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8 {
            self.viewModel.nextFetch()
        }
    }

}

//MARK: - UITableViewDataSource
extension GistsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        let model = viewModel.items.value[indexPath.row]
        cell.model = model
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension GistsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gist = viewModel.items.value[indexPath.row]
        delegate?.presentDetails(model: gist)
    }
    
}
