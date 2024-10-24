//
//  SearchSaveViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 7/7/24.
//

import UIKit
import SnapKit

final class SearchSaveViewController: BaseViewController {

    private var dataSource: UICollectionViewDiffableDataSource<Section, SearchResultDetail>!
    
    private lazy var productCollectionView: UICollectionView = {
        let object = UICollectionView(frame: .zero, collectionViewLayout: saveLayout())
        object.register(SearchSaveCollectionViewCell.self, forCellWithReuseIdentifier: SearchSaveCollectionViewCell.identifier)
        return object
    }()
    
    let viewModel = SearchSaveViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        updateSnapshot()
    }

    override func configureHierarchy() {
        view.addSubview(productCollectionView)
    }
    
    override func configureLayout() {
        productCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        navigationItem.title = "Cart"
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchResultDetail>()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems([], toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    private func mainCellRegistration() -> UICollectionView.CellRegistration<SearchSaveCollectionViewCell, SearchResultDetail> {
        let result = UICollectionView.CellRegistration<SearchSaveCollectionViewCell, SearchResultDetail> { cell, indexPath, itemIdentifier in
//            cell.designCell(input: itemIdentifier.rawValue)
        }
        
        return result
    }
    
    private func configureDataSource() {
        let mainCellRegistration = mainCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, SearchResultDetail>(collectionView: productCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SearchResultDetail) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: mainCellRegistration, for: indexPath, item: identifier)
        }
    }
    
    @objc func likeButtonClicked(sender: UIButton) {

//        let filter = realm.objects(DBTable.self).first(where: {$0.productId == list[sender.tag].productId} )
//        UserInfo.shared.setLikeProduct(isLike: false, forkey: list[sender.tag].productId)
//        
//        viewModel.inputUnLike.value = filter!
//        list.remove(at: sender.tag)

        UIView.performWithoutAnimation {
            productCollectionView.reloadData()
        }
    }
    
    func bindDate() {
        viewModel.outputResult.bind { _ in
            self.productCollectionView.reloadData()
        }
    }
}

extension SearchSaveViewController {
    enum Section: Int, CaseIterable {
        case main
    }

    func saveLayout() -> UICollectionViewLayout {
        let fraction: CGFloat = 1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(fraction))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

