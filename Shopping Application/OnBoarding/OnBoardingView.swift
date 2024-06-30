//
//  OnBoardingView.swift
//  Shopping Application
//
//  Created by 김성률 on 6/29/24.
//

import UIKit
import SnapKit

class OnBoardingView: BaseView {
    
    let titleLabel = UILabel()
    let imageLabel = UIImageView()
    let startButton = UIButton()
    
    override func configureHierarchy() {
    
        addSubview(titleLabel)
        addSubview(imageLabel)
        addSubview(startButton)
        
    }
    
    override func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(90)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        imageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(240)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
    }
    
    override func configureUI() {
        
        titleLabel.text = "MeaningOut"
        titleLabel.textColor = CustomDesign.orange
        titleLabel.font = .systemFont(ofSize: 40, weight: .heavy)
        titleLabel.textAlignment = .center
        
        imageLabel.image = UIImage(named: "launch")
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = CustomDesign.orange
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 20
        
        // mode setting - setup mode
        UserDefaults.standard.set(ProfileMode.setup.rawValue, forKey: "mode")
    }
    
    
}
