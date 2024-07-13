//
//  SearchSaveViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 7/7/24.
//

import UIKit
import SnapKit
import Alamofire
import RealmSwift

class SearchSaveViewController: BaseViewController {

    lazy var productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let line = UIView()
    
    let realm = try! Realm()
    var list: [DBTable] = []
    var folder: Folder?
    
    var start = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.register(SearchSaveCollectionViewCell.self, forCellWithReuseIdentifier: SearchSaveCollectionViewCell.identifier)
        
        if let folder = folder {
            let value = folder.detail
            list = Array(value)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        productCollectionView.reloadData()
    }
    
    override func configureHierarchy() {
        view.addSubview(line)
        view.addSubview(productCollectionView)
    }
    
    override func configureLayout() {
        
        line.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        
        if let folder = folder {
            navigationItem.title = folder.name
        }
        
    }
    
    @objc func likeButtonClicked(sender: UIButton) {
    
        ConstantTable.likeCount = UserDefaultsManager.totalLike
        
        let filterProduct = realm.objects(DBTable.self).where {
            $0.productId == self.list[sender.tag].productId
        }
        
        try! realm.write {
            UserDefaults.standard.set(false, forKey: list[sender.tag].productId)
            realm.delete(filterProduct)
            ConstantTable.likeCount -= 1
        }
        
        UserDefaultsManager.totalLike = ConstantTable.likeCount
        
        UIView.performWithoutAnimation {
            productCollectionView.reloadData()
        }
    }
}

extension SearchSaveViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: SearchSaveCollectionViewCell.identifier, for: indexPath) as? SearchSaveCollectionViewCell else { return UICollectionViewCell() }
        
        cell.designCell(transition: list[indexPath.row])
        
        cell.goodButton.tag = indexPath.row
        cell.goodButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let data = DBTable(productId: list[indexPath.row].productId, productImage: list[indexPath.row].productImage, productCompany: list[indexPath.row].productCompany, productName: list[indexPath.row].productName, productPrice: list[indexPath.row].productPrice, productLink: list[indexPath.row].productLink)

        let vc = SearchWebViewController()
//        vc.data = data
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchSaveViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 68
        
        layout.itemSize = CGSize(width: width/2, height: 280)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 2, left: 14, bottom: 10, right: 14)
        
        return layout
    }
}
