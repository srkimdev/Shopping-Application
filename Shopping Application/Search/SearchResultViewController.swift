//
//  SearchResultViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit
import SnapKit
import Alamofire
import RealmSwift

final class SearchResultViewController: BaseViewController {

    lazy var productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    let line = UIView()
    let totalLabel = UILabel()
    let accurateButton = UIButton()
    let dateButton = UIButton()
    let priceUpButton = UIButton()
    let priceDownButton = UIButton()
    
    let realmrepository = RealmRepository()
    let realm = try! Realm()
    var data: String?
    var list: [SearchResultDetail] = []
    var totalPage = 0
    var start = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callRequest(text: data!) { value in
            self.alamofireDesign(value: value)
        }
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.prefetchDataSource = self

        productCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        
        accurateButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
        priceUpButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
        priceDownButton.addTarget(self, action: #selector(arrayButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productCollectionView.reloadData()
    }
    
    override func configureHierarchy() {
        
        view.addSubview(line)
        view.addSubview(totalLabel)
        view.addSubview(accurateButton)
        view.addSubview(dateButton)
        view.addSubview(priceUpButton)
        view.addSubview(priceDownButton)
        view.addSubview(productCollectionView)
    }
    
    override func configureLayout() {
        
        line.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.height.equalTo(24)
        }
        
        accurateButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.height.equalTo(28)
            make.width.equalTo(60)
        }
        
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(accurateButton.snp.trailing).offset(8)
            make.height.equalTo(28)
            make.width.equalTo(60)
        }
        
        priceUpButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(dateButton.snp.trailing).offset(8)
            make.height.equalTo(28)
            make.width.equalTo(80)
        }
        
        priceDownButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(priceUpButton.snp.trailing).offset(8)
            make.height.equalTo(28)
            make.width.equalTo(80)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(accurateButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func configureUI() {
        
        view.backgroundColor = CustomDesign.viewBackgoundColor
        navigationItem.title = data
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        item.tintColor = CustomDesign.itemTintColor
        navigationItem.leftBarButtonItem = item
        
        line.backgroundColor = CustomDesign.lineColor
        
        totalLabel.textColor = CustomDesign.orange
        totalLabel.font = .boldSystemFont(ofSize: 15)
        
        let buttonArray = [accurateButton, dateButton, priceUpButton, priceDownButton]
        
        for item in 0...3 {
            buttonDesign(button: buttonArray[item], buttonName: ConstantTable.arrayButton[item])
            buttonArray[item].tag = item
        }
        
        accurateButton.backgroundColor = .black
        accurateButton.setTitleColor(.white, for: .normal)
        
    }
    
    private func callRequest(text: String, completionHandler: @escaping (SearchResult) -> Void) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)&display=30&start=\(start)&sort=\(ConstantTable.sortSelect[ConstantTable.sortOption])"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIkey.Id,
            "X-Naver-Client-Secret": APIkey.Secret
        ]
        
        // api communication with url, header
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
                
            case .success(let value):

                completionHandler(value)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    // go back
//    @objc func backButtonClicked() {
//        navigationController?.popViewController(animated: true)
//    }
    
    @objc func arrayButtonClicked(sender: UIButton) {
        
        // sort by arraybutton, page is set to 1
        start = 1
        ConstantTable.sortOption = sender.tag

        callRequest(text: data!) { value in
            self.alamofireDesign(value: value)
        }
        
        // button view change
        [accurateButton, dateButton, priceUpButton, priceDownButton].forEach { button in
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }
        sender.backgroundColor = .black
        sender.setTitleColor(.white, for: .normal)
            
    }
    
    @objc func likeButtonClicked(sender: UIButton) {
        
        // check product has like or not, and reverse
        var like: Bool = UserDefaults.standard.bool(forKey: list[sender.tag].productId)
        like.toggle()
    
        // count total like
        ConstantTable.likeCount = UserDefaultsManager.totalLike
        
        let task = DBTable(productId: list[sender.tag].productId, productImage: list[sender.tag].image, productCompany: list[sender.tag].mallName, productName: list[sender.tag].title, productPrice: list[sender.tag].lprice, productLink: list[sender.tag].link)
        
        if like {
            
            var folder: Folder?
            let list = realm.objects(Folder.self)
            if task.productCompany == "네이버" {
                
                folder = list[1]
                
            } else {
                
                folder = list[2]
            }
            
            realmrepository.createItem(task, folder: folder ?? list[0])
            ConstantTable.likeCount += 1
            
        } else {
            
            ConstantTable.likeCount -= 1
            
            let filterProduct = realm.objects(DBTable.self).filter {
                $0.productId == self.list[sender.tag].productId
            }
            
            try! realm.write {
                realm.delete(filterProduct)
            }
            
        }
        
        // save total like, isLike
        UserDefaultsManager.totalLike = ConstantTable.likeCount
        UserDefaults.standard.set(like, forKey: list[sender.tag].productId)
        
        UIView.performWithoutAnimation {
            productCollectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
        }
        
    }

}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        cell.designCell(transition: list[indexPath.row])
        
        cell.goodButton.tag = indexPath.row
        cell.goodButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = DBTable(productId: list[indexPath.row].productId, productImage: list[indexPath.row].image, productCompany: list[indexPath.row].mallName, productName: list[indexPath.row].title, productPrice: list[indexPath.row].lprice, productLink: list[indexPath.row].link)
        
        // go to webview
        let item = UIBarButtonItem(title: "")
        navigationItem.backBarButtonItem = item
        item.tintColor = .black
        
        let vc = SearchWebViewController()
        vc.data = data
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
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

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    
    // pagenation
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for item in indexPaths {
            if list.count - 4 == item.row {
                start += 30
                if totalPage != start {
                    callRequest(text: data!) { value in
                        self.alamofireDesign(value: value)
                    }
                }
            }
        }
    }
}

extension SearchResultViewController {
    
    // custom array buttons
    private func buttonDesign(button: UIButton, buttonName: String) {
        
        button.setTitle(buttonName, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 15
        
    }
    
    private func alamofireDesign(value: SearchResult) {
        
        let totalCount = value.total
        self.totalLabel.text = "\(ConstantTable.formatNumberString(number: totalCount))개의 검색 결과"
        
        var filteredList = [SearchResultDetail]()
        
        if self.start == 1 {
            
            for item in value.items {
                filteredList.append(item)
            }
            
            self.list = filteredList
            
        } else {
            
            // pagenation
            for item in value.items {
                filteredList.append(item)
            }
            
            self.list.append(contentsOf: filteredList)
            
        }
        
        self.productCollectionView.reloadData()
        
        // scroll to top
        if self.start == 1 {
            self.productCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}
