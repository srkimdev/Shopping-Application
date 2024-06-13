//
//  OnBoardingViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/13/24.
//

import UIKit
import SnapKit

class OnBoardingViewController: UIViewController {

    let titleLabel = UILabel()
    let imageLabel = UIImageView()
    let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureUI()
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        
    }
    
    func configureHierarchy() {
        
        view.addSubview(titleLabel)
        view.addSubview(imageLabel)
        view.addSubview(startButton)
        
    }
    
    func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(90)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        imageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.height.equalTo(280)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        titleLabel.text = "MeaningOut"
        titleLabel.textColor = #colorLiteral(red: 0.8805426955, green: 0.5620557666, blue: 0.3212787211, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 40, weight: .heavy)
        titleLabel.textAlignment = .center
        
        imageLabel.image = UIImage(systemName: "star")
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = #colorLiteral(red: 0.8805426955, green: 0.5620557666, blue: 0.3212787211, alpha: 1)
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 20
        
//        nameLabel.text = "김성률"
//        nameLabel.textColor = #colorLiteral(red: 0.8805426955, green: 0.5620557666, blue: 0.3212787211, alpha: 1)
//        nameLabel.font = .boldSystemFont(ofSize: 20)
//        nameLabel.textAlignment = .center
        
    }
    
    @objc func startButtonClicked() {
        
        let vc = ProfileSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }

    
}
