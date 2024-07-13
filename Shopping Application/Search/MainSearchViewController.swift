//
//  MainSearchViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit
import SnapKit

final class MainSearchViewController: BaseViewController {

    let searchBar = UISearchBar()
    let searchBarLine = UIView()
    let noRecentImage = UIImageView()
    let noRecentLabel = UILabel()
    let recentLabel = UILabel()
    let deleteAllButton = UIButton()
    let searchListTableView = UITableView()
    
    var searchList: [String] = [] {
        didSet {
            viewModel.inputIsText.value = searchList
            UserDefaults.standard.set(searchList, forKey: "RecentSearches")
            searchListTableView.reloadData()
        }
    }
    
    let viewModel = MainSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        searchListTableView.register(MainSearchTableViewCell.self, forCellReuseIdentifier: MainSearchTableViewCell.identifier)
        
        searchList = loadRecentSearches()
        
        bindData()
    }

    override func configureHierarchy() {
        
        view.addSubview(searchBar)
        view.addSubview(searchBarLine)
        view.addSubview(noRecentImage)
        view.addSubview(noRecentLabel)
        view.addSubview(recentLabel)
        view.addSubview(deleteAllButton)
        view.addSubview(searchListTableView)
    }
    
    override func configureLayout() {
        
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
        
        searchListTableView.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        
        navigationItem.title = "\(UserInfo.shared.userName)'s MEANING OUT"
        
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
        
        searchListTableView.rowHeight = 40
        searchListTableView.separatorStyle = .none
    }
    
    override func configureAction() {
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonClicked), for: .touchUpInside)
    }

    @objc func deleteButtonClicked(sender: UIButton) {
        searchList.remove(at: sender.tag)
    }

    @objc func deleteAllButtonClicked() {
        searchList.removeAll()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MainSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.contains(" ") else {
            showAlertOnlyForCheck(title: "검색어를 입력해주세요.")
            searchBar.text = nil
            return
        }
        
        searchBar.text = nil
        
        topToRecentSearch(search: text)
        UserInfo.shared.recentSearchText = text
        
        let vc = SearchResultViewController()
        vc.data = UserInfo.shared.recentSearchText
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchListTableView.dequeueReusableCell(withIdentifier: MainSearchTableViewCell.identifier, for: indexPath) as! MainSearchTableViewCell
        
        cell.designCell(transition: searchList[indexPath.row])
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserInfo.shared.recentSearchText = searchList[indexPath.row]
        topToRecentSearch(search: UserInfo.shared.recentSearchText)

        let vc = SearchResultViewController()
        vc.data = UserInfo.shared.recentSearchText
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainSearchViewController {
    
    private func bindData() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        viewModel.outputIsText.bind { value in

            self.recentLabel.isHidden = !value
            self.deleteAllButton.isHidden = !value
            self.searchListTableView.isHidden = !value
            
            self.noRecentImage.isHidden = value
            self.noRecentLabel.isHidden = value
            
            if value {
                tapGesture.cancelsTouchesInView = !value
                self.searchListTableView.addGestureRecognizer(tapGesture)
            } else {
                self.view.addGestureRecognizer(tapGesture)
            }
        }
    }

    private func topToRecentSearch(search: String) {
        if searchList.contains(search) {
            searchList.removeAll { $0 == search }
        }
        searchList.insert(search, at: 0)
    }
    
    private func loadRecentSearches() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    }
}
