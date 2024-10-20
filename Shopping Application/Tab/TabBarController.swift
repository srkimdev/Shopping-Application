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
        
        let shoes = ShowShoesViewController()
        let nav2 = UINavigationController(rootViewController: shoes)
        nav2.tabBarItem = UITabBarItem(title: "카테고리", image: UIImage(systemName: "star"), tag: 1)
        
        let save = FolderViewController()
        let nav3 = UINavigationController(rootViewController: save)
        nav3.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), tag: 2)
        
        let setting = MainSettingViewController()
        let nav4 = UINavigationController(rootViewController: setting)
        nav4.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 3)
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }
}

