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

final class SearchSaveViewController: BaseViewController {

    lazy var productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let line = UIView()
    
    let realm = try! Realm()
    var list: [DBTable] = []
    var folder: Folder?
    let viewModel = SearchSaveViewModel()

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

        let filter = realm.objects(DBTable.self).first(where: {$0.productId == list[sender.tag].productId} )
        UserInfo.shared.setLikeProduct(isLike: false, forkey: list[sender.tag].productId)
        
        viewModel.inputUnLike.value = filter!
        list.remove(at: sender.tag)

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

extension SearchSaveViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: SearchSaveCollectionViewCell.identifier, for: indexPath) as? SearchSaveCollectionViewCell else { return UICollectionViewCell() }
        
        cell.designCell(transition: list[indexPath.item])
        
        cell.goodButton.tag = indexPath.item
        cell.goodButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = list[indexPath.item]
        let transition = DBTable(productId: data.productId, image: data.image, mallName: data.mallName, title: data.title, lprice: data.lprice, link: data.link)
        
        let vc = SearchWebViewController()
        vc.data = transition
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
