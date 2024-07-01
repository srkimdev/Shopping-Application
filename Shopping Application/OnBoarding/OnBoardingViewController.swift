//
//  OnBoardingViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/13/24.
//

import UIKit
import SnapKit

final class OnBoardingViewController: BaseViewController {

    let mainView = OnBoardingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        
        // mode setting - setup mode
        UserDefaults.standard.set(ProfileMode.setup.rawValue, forKey: "mode")
    }
    
    override func loadView() {
        view = mainView
    }
    
    @objc func startButtonClicked() {
        let vc = ProfileSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
