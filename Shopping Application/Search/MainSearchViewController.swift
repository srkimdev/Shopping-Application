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
    let tableViewLine = UIView()
    
    var recentSearches: [String] = [] {
        
        didSet {
            UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
            searchListTableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        configureHierarchy()
        configureLayout()
        configureUI()

        searchBar.delegate = self
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        searchListTableView.register(MainSearchTableViewCell.self, forCellReuseIdentifier: MainSearchTableViewCell.identifier)
        searchListTableView.addGestureRecognizer(tapGesture)
        
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonClicked), for: .touchUpInside)
        
        recentSearches = loadRecentSearches()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isRecentText()
    }

    func configureHierarchy() {
        
        view.addSubview(searchBar)
        view.addSubview(searchBarLine)
        view.addSubview(noRecentImage)
        view.addSubview(noRecentLabel)
        view.addSubview(recentLabel)
        view.addSubview(deleteAllButton)
        view.addSubview(tableViewLine)
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
            make.top.equalTo(searchBarLine.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(30)
        }
        
        deleteAllButton.snp.makeConstraints { make in
            make.top.equalTo(searchBarLine.snp.bottom).offset(12)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(30)
        }
        
        tableViewLine.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        searchListTableView.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func configureUI() {
        
        view.backgroundColor = CustomDesign.viewBackgoundColor
        navigationItem.title = "\(UserDefaults.standard.string(forKey: "userName")!)'s MEANING OUT"
        
        searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        searchBar.searchBarStyle = .minimal
        searchBarLine.backgroundColor = CustomDesign.lineColor
        
        noRecentImage.image = UIImage(named: "empty")
        
        noRecentLabel.text = "최근 검색어가 없어요"
        noRecentLabel.font = .boldSystemFont(ofSize: 15)
        noRecentLabel.textAlignment = .center
        
        recentLabel.text = "최근 검색"
        recentLabel.font = .boldSystemFont(ofSize: 14)
        
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.setTitleColor(CustomDesign.orange, for: .normal)
        deleteAllButton.titleLabel?.font = .systemFont(ofSize: 14)
        
        tableViewLine.backgroundColor = CustomDesign.lineColor
        
        searchListTableView.rowHeight = 40
        searchListTableView.separatorStyle = .none
    }
    
    @objc func deleteButtonClicked(sender: UIButton) {
        recentSearches.remove(at: sender.tag)
    }
    
    @objc func deleteAllButtonClicked() {
        recentSearches.removeAll()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension MainSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else { return }
        saveRecentSearch(search: text)
        searchBar.text = ""
        
        let vc = SearchResultViewController()
        vc.data = text
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchListTableView.dequeueReusableCell(withIdentifier: MainSearchTableViewCell.identifier, for: indexPath) as! MainSearchTableViewCell
        
        cell.designCell(transition: recentSearches[indexPath.row])
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = SearchResultViewController()
        let temp = recentSearches[indexPath.row]
        vc.data = temp
        
        recentSearches.remove(at: indexPath.row)
        recentSearches.insert(temp, at: 0)
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension MainSearchViewController {
    
    func isRecentText() {
        
        if recentSearches.count > 0 {
            recentLabel.isHidden = false
            deleteAllButton.isHidden = false
            searchListTableView.isHidden = false
            
            noRecentImage.isHidden = true
            noRecentLabel.isHidden = true
            
        } else {
            recentLabel.isHidden = true
            deleteAllButton.isHidden = true
            searchListTableView.isHidden = true
            
            noRecentImage.isHidden = false
            noRecentLabel.isHidden = false
        }
        
    }
    
    func saveRecentSearch(search: String) {
        if recentSearches.contains(search) {
            recentSearches.removeAll { $0 == search }
        }
        recentSearches.insert(search, at: 0)
    }
    
    func loadRecentSearches() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    }
    
}
