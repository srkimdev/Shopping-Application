//
//  SearchResultViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit
import SnapKit
import Alamofire

class SearchResultViewController: UIViewController {

    lazy var productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    let line = UIView()
    let totalLabel = UILabel()
    let accurateButton = UIButton()
    let dateButton = UIButton()
    let priceUpButton = UIButton()
    let priceDownButton = UIButton()
    
    var data: String?
    var list: [SearchResultDetail] = []
    var totalPage = 0
    var start = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureUI()
        callRequest(text: data!)
        
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
    
    func configureHierarchy() {
        
        view.addSubview(line)
        view.addSubview(totalLabel)
        view.addSubview(accurateButton)
        view.addSubview(dateButton)
        view.addSubview(priceUpButton)
        view.addSubview(priceDownButton)
        view.addSubview(productCollectionView)
        
    }
    
    func configureLayout() {
        
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
    
    func configureUI() {
        
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
    
    func callRequest(text: String) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)&display=30&start=\(start)&sort=\(ConstantTable.sortSelect[ConstantTable.sortOption])"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIkey.Id,
            "X-Naver-Client-Secret": APIkey.Secret
        ]
        
        // api communication with url, header
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
                
            case .success(let value):

                var totalCount = 0
                totalCount = value.total
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
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    // go back
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func arrayButtonClicked(sender: UIButton) {
        
        // sort by arraybutton, page is set to 1
        start = 1
        ConstantTable.sortOption = sender.tag
        callRequest(text: data!)
        
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
        ConstantTable.likeCount = UserDefaults.standard.integer(forKey: "totalLike")
        
        if like {
            ConstantTable.likeCount += 1
        } else {
            ConstantTable.likeCount -= 1
        }
        
        // save total like, isLike
        UserDefaults.standard.set(ConstantTable.likeCount, forKey: "totalLike")
        UserDefaults.standard.set(like, forKey: list[sender.tag].productId)
        productCollectionView.reloadData()
        
    }

}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        
        cell.designCell(transition: list[indexPath.row])
        cell.goodButton.tag = indexPath.row
        
        let key = list[indexPath.row].productId
        
        // change button image
        if UserDefaults.standard.bool(forKey: key) {
            cell.goodButton.backgroundColor = .white
            cell.goodButton.alpha = 1
            cell.goodButton.setImage(CustomDesign.likeImage, for: .normal)
            
        } else {
            cell.goodButton.backgroundColor = .black
            cell.goodButton.alpha = 0.3
            cell.goodButton.setImage(CustomDesign.unlikeImage, for: .normal)
        }
        
        cell.goodButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // data transtion - itemTitle, link, productId
        let data = WebViewInfo(text: list[indexPath.row].link, titlelabel: list[indexPath.row].title, key: list[indexPath.row].productId)
        
        // go to webview
        let item = UIBarButtonItem(title: "")
        navigationItem.backBarButtonItem = item
        item.tintColor = .black
        
        let vc = SearchWebViewController(data: data)
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
                    callRequest(text: data!)
                }
            }
        }
    }
}

extension SearchResultViewController {
    
    // custom array buttons
    func buttonDesign(button: UIButton, buttonName: String) {
        
        button.setTitle(buttonName, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 15
        
    }
    
}
