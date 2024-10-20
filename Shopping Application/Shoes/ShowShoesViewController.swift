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
    
    private lazy var categoryCollectionView: UICollectionView = {
        let object = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout())
        object.delegate = self
        object.dataSource = self
        object.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        return object
    }()
    
    private lazy var productCollectionView: UICollectionView = {
        let object = UICollectionView(frame: .zero, collectionViewLayout: productLayout())
        object.delegate = self
        object.dataSource = self
        object.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(brandLabel)
        view.addSubview(categoryCollectionView)
        view.addSubview(productCollectionView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(44)
        }
        
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(240)
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
        } else {
            guard let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
            
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
    
    func productLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 2
        layout.itemSize = CGSize(width: width, height: width / 0.618)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return layout
    }
    
}

extension ShowShoesViewController: UISearchBarDelegate {
    
}
