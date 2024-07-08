//
//  FolderViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 7/8/24.
//

import UIKit
import SnapKit

class FolderViewController: BaseViewController {

    let folderTableView = UITableView()
    
    var list: [Folder] = []
    
    let repository = RealmRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        folderTableView.delegate = self
        folderTableView.dataSource = self
        folderTableView.register(FolderTableViewCell.self, forCellReuseIdentifier: FolderTableViewCell.identifier)
        
        folderTableView.rowHeight = 50
        
        list = repository.fetchFolder()
        print(list)
        repository.detectRealmURL()
    }
    
    override func configureHierarchy() {
        view.addSubview(folderTableView)
    }
    
    override func configureLayout() {
        folderTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        navigationItem.title = "내 폴더"
    }
    
}

extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = folderTableView.dequeueReusableCell(withIdentifier: FolderTableViewCell.identifier, for: indexPath) as! FolderTableViewCell
        
        let data = list[indexPath.row]
        
        cell.folderName.text = data.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = SearchSaveViewController()
        vc.folder = list[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
