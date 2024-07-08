//
//  TabBarController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/14/24.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = CustomDesign.orange
        tabBar.unselectedItemTintColor = .lightGray
        
        let search = MainSearchViewController()
        let nav1 = UINavigationController(rootViewController: search)
        nav1.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let save = FolderViewController()
        let nav2 = UINavigationController(rootViewController: save)
        nav2.tabBarItem = UITabBarItem(title: "내 폴더", image: UIImage(systemName: "book"), tag: 1)
        
        let setting = MainSettingViewController()
        let nav3 = UINavigationController(rootViewController: setting)
        nav3.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 2)
        
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
    
}

