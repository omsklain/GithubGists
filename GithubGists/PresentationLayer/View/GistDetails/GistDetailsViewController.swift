//
//  GistDetailsViewController.swift
//  GithubGists
//
//  Created by Константин Туголуков on 25.06.2022.
//

import UIKit

class GistDetailsViewController: UIViewController {
    
    let viewModel: GistDetailsViewModel
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    init?(coder: NSCoder, viewModel: GistDetailsViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.gist.firstFileName
        setupCollectionView()
        setupDynamicValues()
    }
    
    private func setupCollectionView() {
        collectionView.refreshControl = refreshControl
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
           let collectionView = collectionView {
            flowLayout.estimatedItemSize = CGSize(width: collectionView.referenceWidth(), height: 500)
        }
        
        let headerNib = UINib(nibName: "DetailsHeaderCollectionReusableView", bundle: nil)
        self.collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "detailsHeader")
        
        let topNib = UINib(nibName: "DetailsTopCollectionViewCell", bundle: nil)
        collectionView.register(topNib, forCellWithReuseIdentifier: "DetailsTopCollectionViewCell")
        let filesNib = UINib(nibName: "DetailsFileCollectionViewCell", bundle: nil)
        collectionView.register(filesNib, forCellWithReuseIdentifier: "DetailsFileCollectionViewCell")
        let commitNib = UINib(nibName: "DetailsCommitCollectionViewCell", bundle: nil)
        collectionView.register(commitNib, forCellWithReuseIdentifier: "DetailsCommitCollectionViewCell")
    }
    
    private func setupDynamicValues() {
        
        viewModel.files.bind { [weak self] filesSectionModel in
            self?.collectionView.reloadSections(IndexSet(integer: 1))
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.commits.bind { [weak self] commitsSectionModel in
            self?.collectionView.reloadSections(IndexSet(integer: 2))
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.errors.bind { [weak self] error in
            let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: .default))
            self?.present(alert, animated: true, completion: { self?.refreshControl.endRefreshing() })
        }
    }
    
    @objc func handleRefresh() {
        viewModel.updateData()
    }

}

//MARK: - UICollectionViewDataSource
extension GistDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:return 1
            case 1:return viewModel.files.value.count <= 5 ? viewModel.files.value.count : 5
            case 2:return viewModel.commits.value.count
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
            case 1: return CGSize(width: collectionView.referenceWidth(), height: 40)
            case 2: return CGSize(width: collectionView.referenceWidth(), height: 40)
            default: return CGSize(width: collectionView.referenceWidth(), height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader,
           let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "detailsHeader", for: indexPath) as? DetailsHeaderCollectionReusableView {
            if indexPath.section == 1 { sectionHeader.configure(title: "Files") }
            if indexPath.section == 2 { sectionHeader.configure(title: "Commits") }
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsTopCollectionViewCell", for: indexPath) as? DetailsTopCollectionViewCell {
            cell.model = viewModel.gist
            return cell
        }
        if indexPath.section == 1, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsFileCollectionViewCell", for: indexPath) as? DetailsFileCollectionViewCell {
            cell.model = viewModel.files.value[indexPath.row]
            return cell
        }
        if indexPath.section == 2, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCommitCollectionViewCell", for: indexPath) as? DetailsCommitCollectionViewCell {
            cell.model = viewModel.commits.value[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
}

//MARK: - UICollectionViewDataSource
extension GistDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let gistSelect = viewModel.files.value[indexPath.row]
            let fileDetails = UIStoryboard(name: "GistDetails", bundle: nil).instantiateViewController(identifier: "FileViewController") { coder in
                return FileViewController(coder: coder, fileUrlString: gistSelect.rawURL)
            }
            fileDetails.title = gistSelect.filename
            self.navigationController?.pushViewController(fileDetails, animated: true)
        }
    }
    
}

//MARK: - ReferenceWidth
fileprivate extension UICollectionView {
    func referenceWidth() -> CGFloat {
        guard let sectionInset = (self.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset else {
            return .zero
        }
        let referenceWidth = self.safeAreaLayoutGuide.layoutFrame.width
        - sectionInset.left
        - sectionInset.right
        return referenceWidth
    }
}
