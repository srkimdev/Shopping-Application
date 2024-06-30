//
//  OnBoardingViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/13/24.
//

import UIKit
import SnapKit

class OnBoardingViewController: BaseViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        
    }
    
    
    
    @objc func startButtonClicked() {
        let vc = ProfileSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
