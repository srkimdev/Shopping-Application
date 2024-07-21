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
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultsManager.mode = ProfileMode.setup.rawValue
    }
    
    override func configureAction() {
        mainView.startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    @objc func startButtonClicked() {
        transitionScreen(vc: ProfileSettingViewController(), style: .push)
    }
}
