//
//  MainSettingViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit

class MainSettingViewController: UIViewController {

    let settingTableView = UITableView()
    let list = ["나의 장바구니 목록", "자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureUI()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingProfileTableViewCell.self, forCellReuseIdentifier: SettingProfileTableViewCell.identifier)
        settingTableView.register(SettingOtherTableViewCell.self, forCellReuseIdentifier: SettingOtherTableViewCell.identifier)
        
    }
    
    func configureHierarchy() {
        
        view.addSubview(settingTableView)
        
    }
    
    func configureLayout() {
        
        settingTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        navigationItem.title = "SETTING"
        
    }

}

extension MainSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = settingTableView.dequeueReusableCell(withIdentifier: SettingProfileTableViewCell.identifier, for: indexPath) as! SettingProfileTableViewCell
            
            return cell
        } else {
            
            let cell = settingTableView.dequeueReusableCell(withIdentifier: SettingOtherTableViewCell.identifier, for: indexPath) as! SettingOtherTableViewCell
            
            if indexPath.row == 1 {
                
                cell.saveImage.image = UIImage(named: "like_selected")
                cell.countLabel.text = "18개의 상품"
                
            }
            
            cell.designCell(transition: list[indexPath.row - 1])
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 120
        } else {
            return 40
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            
            
        }
        
    }
    
    
}
