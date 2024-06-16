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
    var totalCount = 0
    var totalPage = 0
    var start = 1
    var sortOption = "sim"
    let sortSelect = ["sim", "date", "dsc", "asc"]
    
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
        
        view.backgroundColor = .white
        navigationItem.title = data
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        item.tintColor = .black
        navigationItem.leftBarButtonItem = item
        
        line.backgroundColor = .systemGray5
        
        totalLabel.textColor = #colorLiteral(red: 0.8805426955, green: 0.5620557666, blue: 0.3212787211, alpha: 1)
        totalLabel.font = .boldSystemFont(ofSize: 15)
        
        accurateButton.backgroundColor = .black
        accurateButton.setTitle("정확도", for: .normal)
        accurateButton.setTitleColor(.white, for: .normal)
        accurateButton.titleLabel?.font = .systemFont(ofSize: 13)
        accurateButton.layer.masksToBounds = true
        accurateButton.layer.borderWidth = 1
        accurateButton.layer.borderColor = UIColor.lightGray.cgColor
        accurateButton.layer.cornerRadius = 15
        accurateButton.tag = 0
        
        dateButton.setTitle("날짜순", for: .normal)
        dateButton.setTitleColor(.black, for: .normal)
        dateButton.titleLabel?.font = .systemFont(ofSize: 13)
        dateButton.layer.masksToBounds = true
        dateButton.layer.borderWidth = 1
        dateButton.layer.borderColor = UIColor.lightGray.cgColor
        dateButton.layer.cornerRadius = 15
        dateButton.tag = 1
        
        priceUpButton.setTitle("가격높은순", for: .normal)
        priceUpButton.setTitleColor(.black, for: .normal)
        priceUpButton.titleLabel?.font = .systemFont(ofSize: 13)
        priceUpButton.layer.masksToBounds = true
        priceUpButton.layer.borderWidth = 1
        priceUpButton.layer.borderColor = UIColor.lightGray.cgColor
        priceUpButton.layer.cornerRadius = 15
        priceUpButton.tag = 2
        
        priceDownButton.setTitle("가격낮은순", for: .normal)
        priceDownButton.setTitleColor(.black, for: .normal)
        priceDownButton.titleLabel?.font = .systemFont(ofSize: 13)
        priceDownButton.layer.masksToBounds = true
        priceDownButton.layer.borderWidth = 1
        priceDownButton.layer.borderColor = UIColor.lightGray.cgColor
        priceDownButton.layer.cornerRadius = 15
        priceDownButton.tag = 3
        
    }
    
    func callRequest(text: String) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)&display=30&start=\(start)&sort=\(sortOption)"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "Ot_GH8dUBgvHiLCjiMZn",
            "X-Naver-Client-Secret": "GaWZjoHF6T"
        ]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
                
            case .success(let value):

                self.totalCount = value.total
                self.totalLabel.text = "\(self.formatNumberString(number: self.totalCount))개의 검색 결과"
                
                var filteredList = [SearchResultDetail]()
                
                if self.start == 1 {
                    
                    for item in value.items {
                        filteredList.append(item)
                    }
                    
                    self.list = filteredList
                    
                } else {
                    
                    for item in value.items {
                        filteredList.append(item)
                    }
                    
                    self.list.append(contentsOf: filteredList)
                    
                }
                
                self.productCollectionView.reloadData()
                
                if self.start == 1 {
                    self.productCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    @objc func backButtonClicked() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func arrayButtonClicked(sender: UIButton) {
        
        sortOption = sortSelect[sender.tag]
        callRequest(text: data!)
        
        [accurateButton, dateButton, priceUpButton, priceDownButton].forEach { button in
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }

        sender.backgroundColor = .black
        sender.setTitleColor(.white, for: .normal)
            
    }
    
    @objc func likeButtonClicked(sender: UIButton) {
        
        print(#function)
        var like: Bool = UserDefaults.standard.bool(forKey: list[sender.tag].productId)
        UserDefaults.standard.set(like.toggle(), forKey: list[sender.tag].productId)
        productCollectionView.reloadData()
        
    }
    
    func formatNumberString(number: Int) -> String {
        
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
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
        
        if UserDefaults.standard.bool(forKey: key) {
            cell.goodButton.backgroundColor = .white
            cell.goodButton.setImage(UIImage(named: "like_selected"), for: .normal)
            
        } else {
            cell.goodButton.backgroundColor = .black
            cell.goodButton.alpha = 0.3
            cell.goodButton.setImage(UIImage(named: "like_unselected"), for: .normal)
        }
        
        cell.goodButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = SearchWebViewController()
        vc.text = list[indexPath.row].link
        vc.titleLabel = list[indexPath.row].title
        
        let item = UIBarButtonItem(title: "")
        navigationItem.backBarButtonItem = item
        item.tintColor = .black
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
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
