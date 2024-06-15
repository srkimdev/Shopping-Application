//
//  MainSearchViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit
import SnapKit

class MainSearchViewController: UIViewController {

    let searchBar = UISearchBar()
    let searchBarLine = UIView()
    
    let noRecentImage = UIImageView()
    let noRecentLabel = UILabel()
    
    let recentLabel = UILabel()
    let deleteAllButton = UIButton()
    
    let searchListTableView = UITableView()
    var list: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        
        noRecentImage.isHidden = true
        noRecentLabel.isHidden = true

        searchBar.delegate = self
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        searchListTableView.register(MainSearchTableViewCell.self, forCellReuseIdentifier: MainSearchTableViewCell.identifier)
        
    }
    
    func configureHierarchy() {
        
        view.addSubview(searchBar)
        view.addSubview(searchBarLine)
        view.addSubview(noRecentImage)
        view.addSubview(noRecentLabel)
        view.addSubview(recentLabel)
        view.addSubview(deleteAllButton)
        view.addSubview(searchListTableView)
        
    }
    
    func configureLayout() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(44)
        }
        
        searchBarLine.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(4)
            make.height.equalTo(1)
        }
        
        noRecentImage.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(230)
            make.width.equalTo(280)
        }
        
        noRecentLabel.snp.makeConstraints { make in
            make.top.equalTo(noRecentImage.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBarLine.snp.bottom).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.height.equalTo(30)
        }
        
        deleteAllButton.snp.makeConstraints { make in
            make.top.equalTo(searchBarLine.snp.bottom).offset(12)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(30)
        }
        
        searchListTableView.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        navigationItem.title = "\(UserDefaults.standard.string(forKey: "userName")!)'s MEANING OUT"
        
        searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        searchBar.searchBarStyle = .minimal
        searchBarLine.backgroundColor = .systemGray5
        
        noRecentImage.image = UIImage(named: "empty")
        
        noRecentLabel.text = "최근 검색어가 없어요"
        noRecentLabel.font = .boldSystemFont(ofSize: 15)
        noRecentLabel.textAlignment = .center
        
        recentLabel.text = "최근 검색"
        recentLabel.font = .boldSystemFont(ofSize: 15)
        
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.setTitleColor(#colorLiteral(red: 0.8805426955, green: 0.5620557666, blue: 0.3212787211, alpha: 1), for: .normal)
        
        searchListTableView.rowHeight = 40
    }
    
}

extension MainSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let vc = SearchResultViewController()
        vc.data = searchBar.text
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchListTableView.dequeueReusableCell(withIdentifier: MainSearchTableViewCell.identifier, for: indexPath)
        
        return cell
    }
    
}
