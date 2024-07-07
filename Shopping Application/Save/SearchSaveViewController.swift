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
    var list: Results<DBTable>!
    var start = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.register(SearchSaveCollectionViewCell.self, forCellWithReuseIdentifier: SearchSaveCollectionViewCell.identifier)
        
        list = realm.objects(DBTable.self).sorted(byKeyPath: "id", ascending: true)
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
        navigationItem.title = "좋아요 리스트"
    }
    
    @objc func likeButtonClicked(sender: UIButton) {
        
        // check product has like or not, and reverse
        var like: Bool = UserDefaults.standard.bool(forKey: list[sender.tag].productId)
        like.toggle()
    
        // count total like
        ConstantTable.likeCount = UserDefaultsManager.totalLike
        
        if like {
            ConstantTable.likeCount += 1
        } else {
            ConstantTable.likeCount -= 1
        }
        
        // save total like, isLike
        UserDefaultsManager.totalLike = ConstantTable.likeCount
        UserDefaults.standard.set(like, forKey: list[sender.tag].productId)
        
        UIView.performWithoutAnimation {
            productCollectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
        }
        
    }

}

extension SearchSaveViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: SearchSaveCollectionViewCell.identifier, for: indexPath) as? SearchSaveCollectionViewCell else { return UICollectionViewCell() }
        
        print(2)
        cell.designCell(transition: list[indexPath.row])
        
        cell.goodButton.tag = indexPath.row
        cell.goodButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // data transtion - itemTitle, link, productId
        let data = WebViewInfo(text: list[indexPath.row].productLink, titlelabel: list[indexPath.row].productName, key: list[indexPath.row].productId)
        
        // go to webview
        let item = UIBarButtonItem(title: "")
        navigationItem.backBarButtonItem = item
        item.tintColor = .black
        
        let vc = SearchWebViewController(data: data)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchSaveViewController: UICollectionViewDelegateFlowLayout {
    
    // custom collectionViewCell
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
