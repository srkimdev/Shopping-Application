//
//  MainSettingViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit

class MainSettingViewController: UIViewController {

    let settingTableView = UITableView()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaultsManager.fromWhere = true
        settingTableView.reloadData()
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
        return ConstantTable.settingCell.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // profile setting
        if indexPath.row == 0 {
            let cell = settingTableView.dequeueReusableCell(withIdentifier: SettingProfileTableViewCell.identifier, for: indexPath) as! SettingProfileTableViewCell
            
            cell.profileImage.image = UIImage(named: "profile_\(UserDefaultsManager.profileNumber)")
            
            cell.profileName.text = UserDefaultsManager.userName
            
            return cell
            
        // other cells setting
        } else {
            
            let cell = settingTableView.dequeueReusableCell(withIdentifier: SettingOtherTableViewCell.identifier, for: indexPath) as! SettingOtherTableViewCell
            
            if indexPath.row == 1 {
                cell.saveImage.image = CustomDesign.likeImage
                cell.countLabel.text = "\(UserDefaultsManager.totalLike)개의 상품"
            } else {
                cell.saveImage.image = nil
                cell.countLabel.text = nil
            }
            
            // only "탈퇴하기" cell can be selected
            if indexPath.row == 5 {
                cell.isUserInteractionEnabled = true
            } else {
                cell.isUserInteractionEnabled = false
            }
            
            cell.designCell(transition: ConstantTable.settingCell[indexPath.row - 1])
            
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
            
            let vc = ProfileSettingViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 5 {
            
            // all userdefaults will be removed
            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
            }
            
            // alert setting
            let alert = UIAlertController(
                title: "탈퇴하기",
                message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?",
                preferredStyle: .alert)
                
            let check = UIAlertAction(title: "확인", style: .default) {_ in 
                self.initialize()
            }
            
            let cancel = UIAlertAction(title: "취소", style: .cancel)
                
            alert.addAction(cancel)
            alert.addAction(check)
                
            present(alert, animated: true)
        }

    }
    
    
}

extension MainSettingViewController {
    
    // go to OnBoarding screen when you click "확인" button
    func initialize() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let rootViewcontroller = UINavigationController(rootViewController: OnBoardingViewController())
        
        sceneDelegate?.window?.rootViewController = rootViewcontroller
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
}
