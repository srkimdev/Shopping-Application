//
//  ShowShoesViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 10/20/24.
//

import UIKit
import SnapKit

final class ShowShoesViewController: BaseViewController {
    
    struct Product {
        let name: String
    }
    
    let product: [Product] = [
        Product(name: "Nike"),
        Product(name: "Adidas"),
        Product(name: "dddddddd"),
        Product(name: "dddd"),
        Product(name: "dd"),
        Product(name: "ddddddd"),
        Product(name: "ddddddddddddd"),
        Product(name: "ddddd"),
        Product(name: "Nike"),
        Product(name: "Nike"),
    ]
    
    private let scrollView = {
        let object = UIScrollView()
        return object
    }()
    
    private let contentView = {
        let object = UIView()
        return object
    }()
    
    private lazy var searchBar: UISearchBar = {
        let object = UISearchBar()
        object.delegate = self
        object.placeholder = "브랜드, 상품 등을 입력하세요."
        object.searchBarStyle = .minimal
        return object
    }()
    
    private let brandLabel = {
        let object = UILabel()
        object.text = "브랜드 별로 보기"
        object.font = .systemFont(ofSize: 18, weight: .bold)
        return object
    }()
    
    private let recentLabel = {
        let object = UILabel()
        object.text = "신상"
        object.font = .systemFont(ofSize: 18, weight: .bold)
        return object
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let object = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout())
        object.delegate = self
        object.dataSource = self
        object.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        return object
    }()
    
    private lazy var brandProductCollectionView: UICollectionView = {
        let object = UICollectionView(frame: .zero, collectionViewLayout: brandProductLayout())
        object.delegate = self
        object.dataSource = self
        object.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        return object
    }()
    
    private lazy var recentProductCollectionView: UICollectionView = {
        let object = UICollectionView(frame: .zero, collectionViewLayout: recentProductLayout())
        object.delegate = self
        object.dataSource = self
        object.register(RecentProductCollectionViewCell.self, forCellWithReuseIdentifier: RecentProductCollectionViewCell.identifier)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(brandLabel)
        contentView.addSubview(categoryCollectionView)
        contentView.addSubview(brandProductCollectionView)
        contentView.addSubview(recentLabel)
        contentView.addSubview(recentProductCollectionView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        brandProductCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(280)
        }
        
        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(brandProductCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        recentProductCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(190)
            make.bottom.equalToSuperview()
        }
    }

}

extension ShowShoesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.designCell(input: product[indexPath.row].name)
            
            return cell
        } else if collectionView == brandProductCollectionView {
            guard let cell = brandProductCollectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
            
            cell.designCell(input: product[indexPath.row].name)
            
            return cell
        } else {
            guard let cell = recentProductCollectionView.dequeueReusableCell(withReuseIdentifier: RecentProductCollectionViewCell.identifier, for: indexPath) as? RecentProductCollectionViewCell else { return UICollectionViewCell() }
            
            cell.designCell(input: product[indexPath.row].name)
            
            return cell
        }
    }
}

extension ShowShoesViewController: UICollectionViewDelegateFlowLayout {
    func categoryLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return layout
    }
    
    func brandProductLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 2
        layout.itemSize = CGSize(width: width, height: 280)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return layout
    }
    
    func recentProductLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 190)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return layout
    }
}

extension ShowShoesViewController: UISearchBarDelegate {
    
}
