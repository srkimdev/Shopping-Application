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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureUI()
        callRequest(text: data!)
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        
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
            make.height.equalTo(30)
//            make.width.equalTo(60)
        }
        
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(accurateButton.snp.trailing).offset(12)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        priceUpButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(dateButton.snp.trailing).offset(12)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        priceDownButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(priceUpButton.snp.trailing).offset(12)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(accurateButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func configureUI() {
        
        view.backgroundColor = .lightGray
        navigationItem.title = data
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        item.tintColor = .black
        navigationItem.leftBarButtonItem = item
        
        line.backgroundColor = .systemGray5
        
        totalLabel.text = "111111개의 검색 결과"
        totalLabel.textColor = #colorLiteral(red: 0.8805426955, green: 0.5620557666, blue: 0.3212787211, alpha: 1)
        totalLabel.font = .boldSystemFont(ofSize: 15)
        
        accurateButton.backgroundColor = .red
        accurateButton.setTitle("정확도", for: .normal)
        accurateButton.layer.masksToBounds = true
        accurateButton.layer.cornerRadius = 15
        
        dateButton.backgroundColor = .red
        dateButton.setTitle("날짜순", for: .normal)
        
        priceUpButton.backgroundColor = .red
        priceUpButton.setTitle("가격높은순", for: .normal)
        
        priceDownButton.backgroundColor = .red
        priceDownButton.setTitle("가격낮은순", for: .normal)
        
    }
    
    func callRequest(text: String) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "Ot_GH8dUBgvHiLCjiMZn",
            "X-Naver-Client-Secret": "GaWZjoHF6T"
        ]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
                
            case .success(let value):
                print(value)
                self.list = value.items
                
                self.productCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    @objc func backButtonClicked() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func accurateButtonClicked() {
        
    }
    
    @objc func dateButtonClicked() {
        
    }
    
    @objc func priceUpClicked() {
        
    }
    
    @objc func priceDownClicked() {
        
    }

}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        
        cell.designCell(transition: list[indexPath.row])
        
        return cell
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
        layout.sectionInset = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        
        return layout
    }
    
}
