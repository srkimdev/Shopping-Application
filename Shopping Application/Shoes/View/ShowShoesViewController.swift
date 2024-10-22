//
//  ShowShoesViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 10/20/24.
//

import UIKit
import SnapKit

final class ShowShoesViewController: BaseViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, SearchResultDetail>!
    private let viewModel = ShowShoesViewModel()
//    struct Product: Hashable {
//        let name: String
//    }
//    
//    struct Brand: Hashable {
//        let name: String
//    }
//    
//    let product: [Product] = [
//        Product(name: "Nike"),
//        Product(name: "Adidas"),
//        Product(name: "dddddddd"),
//        Product(name: "dddd"),
//        Product(name: "dd"),
//        Product(name: "ddddddd"),
//        Product(name: "ddddddddddddd"),
//        Product(name: "ddddd")
//    ]
//    
//    let brand: [Product] = [
//        Product(name: "Nike"),
//        Product(name: "Nikea"),
//        Product(name: "Nikes"),
//        Product(name: "Niked"),
//        Product(name: "Nikef"),
//        Product(name: "Nikeg"),
//        Product(name: "Nikeh"),
//        Product(name: "Nikej")
//    ]
//    
//    let recent: [Product] = [
//        Product(name: "Nikeadfdfdf"),
//        Product(name: "Nikeas"),
//        Product(name: "Nikesd"),
//        Product(name: "Nikedf"),
//        Product(name: "Nikefg"),
//        Product(name: "Nikegh"),
//        Product(name: "Nikehjh"),
//        Product(name: "Nikejk")
//    ]
    
    private lazy var searchBar: UISearchBar = {
        let object = UISearchBar()
        object.delegate = self
        object.placeholder = "브랜드, 상품 등을 입력하세요."
        object.searchBarStyle = .minimal
        return object
    }()
    
    private lazy var mainCollectionView: UICollectionView = {
        let object = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout())
        object.register(MainCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainCollectionHeaderView.identifier)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.inputTrigger.value = ()
        
        configureDataSource()
        updateSnapshot()
    }
    
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(mainCollectionView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(44)
        }

        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchResultDetail>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([], toSection: .categories)
        
        snapshot.appendItems(viewModel.outputBrandList.value, toSection: .brands)
        snapshot.appendItems(viewModel.outputNewList.value, toSection: .recents)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func categoryCellRegistration() -> UICollectionView.CellRegistration<CategoryCollectionViewCell, SearchResultDetail> {
        let result = UICollectionView.CellRegistration<CategoryCollectionViewCell, SearchResultDetail> { cell, indexPath, itemIdentifier in
//            cell.designCell(input: itemIdentifier.name)
        }
        
        return result
    }
    
    private func brandCellRegistration() -> UICollectionView.CellRegistration<ProductCollectionViewCell, SearchResultDetail> {
        let result = UICollectionView.CellRegistration<ProductCollectionViewCell, SearchResultDetail> { cell, indexPath, itemIdentifier in
//            cell.designCell(input: itemIdentifier.name)
        }
        
        return result
    }
    
    private func recentCellRegistration() -> UICollectionView.CellRegistration<RecentProductCollectionViewCell, SearchResultDetail> {
        let result = UICollectionView.CellRegistration<RecentProductCollectionViewCell, SearchResultDetail> { cell, indexPath, itemIdentifier in
//            cell.designCell(input: itemIdentifier.name)
        }
        
        return result
    }
    
    private func configureDataSource() {
        let categoryCellRegistration = categoryCellRegistration()
        let brandCellRegistration = brandCellRegistration()
        let recentCellRegistration = recentCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, SearchResultDetail>(collectionView: mainCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SearchResultDetail) -> UICollectionViewCell? in

            if Section(rawValue: indexPath.section) == .categories {
                return collectionView.dequeueConfiguredReusableCell(using: categoryCellRegistration, for: indexPath, item: identifier)
            } else if Section(rawValue: indexPath.section) == .brands {
                return collectionView.dequeueConfiguredReusableCell(using: brandCellRegistration, for: indexPath, item: identifier)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: recentCellRegistration, for: indexPath, item: identifier)
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
                
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainCollectionHeaderView.identifier, for: indexPath) as! MainCollectionHeaderView
            
            if indexPath.section == 0 {
                header.titleLabel.text = "브랜드 별 상품"
            } else if indexPath.section == 2 {
                header.titleLabel.text = "신상"
            }
            
            return header
        }
        
    }

}

extension ShowShoesViewController {
    private enum Section: Int, CaseIterable {
        case categories
        case brands
        case recents
    }
    
    func compositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch sectionIndex {
            case 0:
                return self.categoryLayout()
            case 1:
                return self.brandLayout()
            case 2:
                return self.recentLayout()
            default:
                return nil
            }
        }
    }
    
    func categoryLayout() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .fractionalHeight(fraction))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuous
        
        let supplementaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: supplementaryItemSize,
                                                                            elementKind: UICollectionView.elementKindSectionHeader,
                                                                            alignment: .top)
        section.boundarySupplementaryItems = [supplementaryItem]
        
        return section
    }
    
    func brandLayout() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(fraction))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(3/5), heightDimension: .absolute(260))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func recentLayout() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(fraction))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        
        let supplementaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: supplementaryItemSize,
                                                                            elementKind: UICollectionView.elementKindSectionHeader,
                                                                            alignment: .top)
        section.boundarySupplementaryItems = [supplementaryItem]
        
        return section
    }
    
}

extension ShowShoesViewController: UISearchBarDelegate {
    
}
