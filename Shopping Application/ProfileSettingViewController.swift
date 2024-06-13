//
//  ProfileSettingViewController.swift
//  Shopping Application
//
//  Created by 김성률 on 6/13/24.
//

import UIKit
import SnapKit

class ProfileSettingViewController: UIViewController {

    let profileImageButton = UIButton()
    let nicknameTextField = UITextField()
    let textFieldLine = UIView()
    let nicknameStatusLable = UILabel()
    let clearButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(#function)
        configureHierarchy()
        configureLayout()
        configureUI()
        
        clearButton.addTarget(self, action: #selector(clearButtonClicked), for: .touchUpInside)
    }
    
    func configureHierarchy() {
        
        view.addSubview(profileImageButton)
        view.addSubview(nicknameTextField)
        view.addSubview(textFieldLine)
        view.addSubview(nicknameStatusLable)
        view.addSubview(clearButton)
        
    }
    
    func configureLayout() {
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view.self)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(30)
        }
        
        textFieldLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.height.equalTo(1)
        }
        
        nicknameStatusLable.snp.makeConstraints { make in
            make.top.equalTo(textFieldLine.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(24)
        }
        
        clearButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusLable.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(40)
        }
    }
    
    func configureUI() {
        
        navigationItem.title = "PROFILE SETTING"
        view.backgroundColor = .white
        
        profileImageButton.setImage(UIImage(systemName: "star"), for: .normal)
        profileImageButton.contentMode = .scaleAspectFit
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        
        textFieldLine.backgroundColor = .systemGray4
        
        nicknameStatusLable.text = "닉네임에 @ 는 포함할 수 없어요."
        nicknameStatusLable.textColor = #colorLiteral(red: 0.8805426955, green: 0.5620557666, blue: 0.3212787211, alpha: 1)
        nicknameStatusLable.font = .boldSystemFont(ofSize: 13)
        
        clearButton.setTitle("완료", for: .normal)
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        clearButton.backgroundColor = #colorLiteral(red: 0.8805426955, green: 0.5620557666, blue: 0.3212787211, alpha: 1)
        clearButton.layer.masksToBounds = true
        clearButton.layer.cornerRadius = 20
        
    }
    
    @objc func clearButtonClicked() {
        
    }

}
